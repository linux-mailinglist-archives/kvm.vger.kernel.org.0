Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACED785B76
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 17:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236796AbjHWPH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 11:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234731AbjHWPH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 11:07:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95137E7B;
        Wed, 23 Aug 2023 08:07:11 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37NDCcUX022442;
        Wed, 23 Aug 2023 13:23:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=rKG5qhcS04QXyYLaZ89snTLXS9uCs9Q79OWrRuyEpmY=;
 b=VWzTtDPYEaJhf+vZdPOVyG57sUZiXJaOKIbTDDhB5J61G1cO7qJCX7ngJtJrp2gC26Nq
 H6sA489qTR1UoAGeWcMChhQ/eNPMfPUTVl2ttdjG1DkShb/hXvNn1p35FHYNvLxd0yDL
 2YwcYJeI/m3aZHT7meqNMbfyW4zY/UAjehYe3uTJP5WF4Ftm/ls9qmwwhdGVgbldVR5o
 LhqEbLghky1xwrxYR0XL1T9A1M5Gd2j85uyp35bluypcVoDJ65b5sv8AMdVoYx0Q9Ygz
 1rAUJwwLvDa+RzUBGzJQDg7bKZidPmFm0lZxb8fQ4K4aUKoQGiTSRcAT8pZ6bwLaoApn nQ== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3snjstra0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Aug 2023 13:23:44 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37NC3e0b027342;
        Wed, 23 Aug 2023 13:23:43 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn20seks2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Aug 2023 13:23:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37NDNeCf27394704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Aug 2023 13:23:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F102D20043;
        Wed, 23 Aug 2023 13:23:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9ED8F20040;
        Wed, 23 Aug 2023 13:23:39 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 23 Aug 2023 13:23:39 +0000 (GMT)
Date:   Wed, 23 Aug 2023 15:23:38 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Michael Mueller <mimu@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: fix gisa destroy operation might lead to cpu
 stalls
Message-ID: <ZOYIWuq3iqLjDd+q@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20230823124140.3839373-1-mimu@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823124140.3839373-1-mimu@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pooDboz6b08OCWqoeYbn3jS884Sntv_u
X-Proofpoint-ORIG-GUID: pooDboz6b08OCWqoeYbn3jS884Sntv_u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-23_07,2023-08-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 spamscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 impostorscore=0 mlxlogscore=468 suspectscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308230119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 23, 2023 at 02:41:40PM +0200, Michael Mueller wrote:
...
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 9bd0a873f3b1..73153bea6c24 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -3205,8 +3205,10 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
>  	if (gi->alert.mask)
>  		KVM_EVENT(3, "vm 0x%pK has unexpected iam 0x%02x",
>  			  kvm, gi->alert.mask);
> -	while (gisa_in_alert_list(gi->origin))
> -		cpu_relax();
> +	while (gisa_in_alert_list(gi->origin)) {
> +		KVM_EVENT(3, "vm 0x%pK gisa in alert list during destroy", kvm);
> +		process_gib_alert_list();

process_gib_alert_list() has two nested loops and neither of them
does cpu_relax(). I guess, those are needed instead of one you remove?

> +	}
>  	hrtimer_cancel(&gi->timer);
>  	gi->origin = NULL;
>  	VM_EVENT(kvm, 3, "gisa 0x%pK destroyed", gisa);
