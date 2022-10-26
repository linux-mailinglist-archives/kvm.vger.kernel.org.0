Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C8960E241
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 15:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiJZNhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 09:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbiJZNgt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 09:36:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490E110B6A;
        Wed, 26 Oct 2022 06:36:48 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QD0Rbe017465;
        Wed, 26 Oct 2022 13:36:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YAamzQAdZMeKFR38BmEO5b3be9I3tffsjuBsMPwhp90=;
 b=h/6b5PJt0BswfXQelq1N2mTYiWCGumu6nfcx0HxU7cTQgibQgWagEv78F6P3BVKdMbBW
 eBzZqPbqaN6O8dzVRXT6PinAJzVqImrS46BwZ4xndArlPvmr6TNw/PfdgtEfRVtytSXL
 M49jte9+DzGrRwrkE/VWyrXJ/HeG1JR4H8stXTYXEuSMryjTPkZb5faeP017p9SNXpLK
 I3yFqUwW2eTAZtbhVaXGOSLvJt5QnkzuBLgaTEv0t09QR5ih6TokPKcvxfWSLW/IlnB8
 8kaUrMTao/ImsQSOJG/TnPrkCATbavtVK3LZdQDVNHcr1FmoqDKlPnK7slwvT1WvCIvZ BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kf5da9bwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 13:36:47 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29QDaYPw021323;
        Wed, 26 Oct 2022 13:36:47 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kf5da9bvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 13:36:47 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29QDZsPk013672;
        Wed, 26 Oct 2022 13:36:45 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04wdc.us.ibm.com with ESMTP id 3kc859gc38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 13:36:45 +0000
Received: from smtpav04.wdc07v.mail.ibm.com ([9.208.128.116])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29QDai4t9306748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 13:36:45 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40A9758060;
        Wed, 26 Oct 2022 13:36:44 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CEFA58056;
        Wed, 26 Oct 2022 13:36:42 +0000 (GMT)
Received: from [9.160.93.208] (unknown [9.160.93.208])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Oct 2022 13:36:42 +0000 (GMT)
Message-ID: <733949e2-1086-f012-aa39-e3b84feb2688@linux.ibm.com>
Date:   Wed, 26 Oct 2022 09:36:42 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] KVM: s390: pci: Fix allocation size of aift kzdev
 elements
Content-Language: en-US
To:     Rafael Mendonca <rafaelmendsr@gmail.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221026013234.960859-1-rafaelmendsr@gmail.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221026013234.960859-1-rafaelmendsr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Cv4TXOaUDfdvg_Be506w56CdFYzjyV_Z
X-Proofpoint-GUID: vYWzyYMuyG9jVTSSu0NuyE58KC0HAZer
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_06,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1011 mlxlogscore=999
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210260076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/25/22 9:32 PM, Rafael Mendonca wrote:
> The 'kzdev' field of struct 'zpci_aift' is an array of pointers to
> 'kvm_zdev' structs. Allocate the proper size accordingly.
> 
> Reported by Coccinelle:
>   WARNING: Use correct pointer type argument for sizeof
> 
> Fixes: 98b1d33dac5f ("KVM: s390: pci: do initial setup for AEN interpretation")
> Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>

Thanks for reporting & fixing.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>  arch/s390/kvm/pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index c50c1645c0ae..ded1af2ddae9 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -126,7 +126,7 @@ int kvm_s390_pci_aen_init(u8 nisc)
>  		return -EPERM;
>  
>  	mutex_lock(&aift->aift_lock);
> -	aift->kzdev = kcalloc(ZPCI_NR_DEVICES, sizeof(struct kvm_zdev),
> +	aift->kzdev = kcalloc(ZPCI_NR_DEVICES, sizeof(struct kvm_zdev *),
>  			      GFP_KERNEL);
>  	if (!aift->kzdev) {
>  		rc = -ENOMEM;

