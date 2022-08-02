Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D15587797
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbiHBHMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbiHBHMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:12:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782C649B5C
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:12:10 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2726vqDg011796
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 07:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : to : from : message-id : date; s=pp1;
 bh=vN/aNtrLroRGVLLpZlQLVbcriTwmcJwUJignruRKN/E=;
 b=bTYLzRCf35Ct4FcBnQ2MoCR23REkN6pS28mAl0T4pgzCayPovMPnzwEyzSrvyAY1gqnE
 OF+OKb8PS/YqGYWrGdZjrovYurdVqrXgWriByqXz8L2VKFMUimsbEUbpYuu9LlQlD2Bt
 Mghb1QeoJ8G6VrfhntMQ0i+H2rZnnw9XNOBdnm3Li0ZhnHVjAMcdfZSbkp9HFvAhEDA0
 FfPjNFFoCsBKUPFpWSLJLJdAbdHikIUIkMGyk7LMP09X/57XL24czk/lemLl7OWt5bKX
 vzFAPbcfTogf18j+zqtSB0nIUamvK4Gc7yOf1AuMN7fDz4KRli1fHrXfmvwui05w792v SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpy4arecq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 07:12:09 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2726wHhA012936
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 07:12:09 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpy4arec0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 07:12:09 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27275bb5011727;
        Tue, 2 Aug 2022 07:12:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3hmv98ub5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 07:12:07 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2727C4ga28246470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Aug 2022 07:12:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F077AAE056;
        Tue,  2 Aug 2022 07:12:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D556AAE055;
        Tue,  2 Aug 2022 07:12:03 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.89.124])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Aug 2022 07:12:03 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220729082633.277240-3-frankja@linux.ibm.com>
References: <20220729082633.277240-1-frankja@linux.ibm.com> <20220729082633.277240-3-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 2/6] s390x: MAKEFILE: Use $< instead of pathsubst
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <165942432367.253051.17368935462468430956@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Tue, 02 Aug 2022 09:12:03 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BJjHkErNpeCeBMv3Fz9nO49f8QX2_zQ0
X-Proofpoint-GUID: SSI5oMSBeyxxGzNE7YamvmL60pdLG2R4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_03,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 mlxlogscore=611 mlxscore=0 bulkscore=0 phishscore=0
 clxscore=1015 impostorscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208020033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-07-29 10:26:29)
> No need to mangle strings if we already have the value at hand.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
