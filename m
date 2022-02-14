Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467464B558D
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 17:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356116AbiBNQFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 11:05:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356096AbiBNQFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 11:05:49 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC70745ADD
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:05:41 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EF8O3e008456
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:05:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=bFHQnqQ8Alr1nCrBG0oQux7EQx29rZph2P/TiGiVUhA=;
 b=H5/WlHftxW+wKifiYPInqMLG4uHxSzXai3sxoORzTm6Uig8K7I/k1QgCTJrlzmTsxIE7
 vBsOYLulHXA429+RcD19M4NPqKuNS2M0qMk45sp0URhBoy5S2FoBxTvNQaUsWhgnJoy2
 gYXo9DBedbvVkwp0Yv30BW49TduRMDDrj+niyjYXkPemZ2TpSorUl8QC+RTp+HtClXWR
 zTTUxyJ7VJ2u1gaHXeFuzjGlwHX4ItxqnJRexOmjSJuo/Vdse8e/FAlz7DWjbo0QgZiA
 RhBwwQJFie1zJJ0ieq6EtaByijGeajYo/sPTxNbu+b8clYOt4+BgkiSBNeifWOvV7h4c ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e78m0p55f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:05:41 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21EG0CkV004868
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:05:41 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e78m0p54e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 16:05:40 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EFvoZU005826;
        Mon, 14 Feb 2022 16:05:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3e64h965ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 16:05:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21EG5Y4241943512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 16:05:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B47A411C066;
        Mon, 14 Feb 2022 16:05:34 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E17111C052;
        Mon, 14 Feb 2022 16:05:34 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.29.228])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 16:05:34 +0000 (GMT)
Message-ID: <00fd56bc3f305c8b5c72897826acb6399b418bf5.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/6] lib: s390x: smp: guarantee that
 boot CPU has index 0
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        scgl@linux.ibm.com, seiden@linux.ibm.com
Date:   Mon, 14 Feb 2022 17:05:34 +0100
In-Reply-To: <20220204130855.39520-2-imbrenda@linux.ibm.com>
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
         <20220204130855.39520-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: spiNXKDz-J-IE0OZuG6TzbM5m_Kg0dLB
X-Proofpoint-ORIG-GUID: uf7ZldA-KH0jLEt4U69Ab6XwVkKCzF3W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 phishscore=0 impostorscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-04 at 14:08 +0100, Claudio Imbrenda wrote:
> Guarantee that the boot CPU has index 0. This simplifies the
> implementation of tests that require multiple CPUs.
> 
> Also fix a small bug in the allocation of the cpus array.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
