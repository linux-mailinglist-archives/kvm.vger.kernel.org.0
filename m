Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38794B5592
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 17:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356131AbiBNQGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 11:06:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347023AbiBNQGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 11:06:33 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA62FC4D
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:06:25 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EEURwN019585
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:06:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=KH681znlur9EMGTF5uyDdZ8u6EqavVyNxOTsLMGLFEI=;
 b=SXc2457dtSu64s+H9aypjkvTnf8Q52dh5C4oavejdJZ+qY1hIBWNjCHW8MB/A8o6FEcp
 t4Wx2uD/0rQxO0D4JobQRG0huJVsYrNU/JRVxS9KQFH2UPx7ycBBteq5Qb/JlXKLxnOJ
 SyHp1vHUfYNgkqVLw5qF2mzwIG31cY/6J5z8KSviOyRPFuGQtz9T43jjJAK5tPut/wTP
 71CR1/YTJHYOZW84FNZozkXSbXAQQvde3pfJ6t0V32aB1BMLtsqZh19DDDQ1bgAFEwbe
 pLAL03vXLwaca3KLSx4XlQfZmw/TmoUm4cHWPyvAFNi4m9m/zTkYShe6Ag3OYZ/zA1A9 YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e779vpuy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:06:25 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21EFuBuC016156
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:06:24 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e779vpux9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 16:06:24 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EFw05o012169;
        Mon, 14 Feb 2022 16:06:23 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3e645jf6mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 16:06:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21EG6Gnr44630394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 16:06:16 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B987952059;
        Mon, 14 Feb 2022 16:06:16 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.29.228])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5A4F152051;
        Mon, 14 Feb 2022 16:06:16 +0000 (GMT)
Message-ID: <e9f3ac047c3b4d12616bff8cc6c1f565a0304a93.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/6] s390x: smp: use CPU indexes
 instead of addresses
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        scgl@linux.ibm.com, seiden@linux.ibm.com
Date:   Mon, 14 Feb 2022 17:06:16 +0100
In-Reply-To: <20220204130855.39520-4-imbrenda@linux.ibm.com>
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
         <20220204130855.39520-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _dh_5UIytp58K2NRcDC7fEZHXPsdSluu
X-Proofpoint-ORIG-GUID: fYjuLI2mDo6oVdIrtnuHsqx3C9ggOCEa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=987 classifier=spam adjust=0 reason=mlx scancount=1
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
> Adapt the test to the new semantics of the smp_* functions, and use
> CPU
> indexes instead of addresses.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm..com>

