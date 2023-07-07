Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A60E74AD3F
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 10:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjGGInd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 04:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjGGInc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 04:43:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABCBF5
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 01:43:31 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3678dMOj020310;
        Fri, 7 Jul 2023 08:43:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : reply-to :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=F+nMelXtWH0QuLZZqfIic7T5LDe1tQRdK5LmBmr8xe0=;
 b=XXb8ScKb/tJUnCw3dDUNCwMe8XpUwa6nDJV1a9LrkB5nIBi7LvYWBFiNTRD0ANk3/A3P
 tq+BNIxV0rD32fS5G1d1isFPOoKgKNdlFl0C0ggM4QCtuT4FI2AHFRqfK6Q128fAt4yg
 WEoktWaSqbhuemV6TwmoL8gHYhjiFkKfzLRjTkzk+UqnrpgjufjnZyqnL5g3KIpZP14g
 ET6mOY+bC0WLNxI07pw9fa+7meus+EvTBCST3PTgTd/v/J2mINizMMJuhFnmAO3FLOqG
 4qu0v0HdBcT5vKOzHpLp00xLnM083YJ6gRKNPGYXSkorqV7TzZzqiIpsLYPUNdiCrDpf hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rpf2a8ee2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 08:43:03 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3678f5nd025883;
        Fri, 7 Jul 2023 08:43:03 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rpf2a8eck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 08:43:03 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3677w31h024382;
        Fri, 7 Jul 2023 08:43:00 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3rjbddtuv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jul 2023 08:43:00 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3678gwB827263440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jul 2023 08:42:58 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C63520043;
        Fri,  7 Jul 2023 08:42:58 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8E1F2004B;
        Fri,  7 Jul 2023 08:42:55 +0000 (GMT)
Received: from [9.43.6.151] (unknown [9.43.6.151])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jul 2023 08:42:55 +0000 (GMT)
Message-ID: <f9e124ca-809c-11b6-ba57-e4879d29c4b3@linux.ibm.com>
Date:   Fri, 7 Jul 2023 14:12:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v5 3/3] ppc: Enable 2nd DAWR support on p10
Content-Language: en-US
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     qemu-ppc@nongnu.org, mikey@neuling.org, kvm@vger.kernel.org,
        mst@redhat.com, mpe@ellerman.id.au, cohuck@redhat.com,
        qemu-devel@nongnu.org, groug@kaod.org, paulus@samba.org,
        clg@kaod.org, pbonzini@redhat.com, ravi.bangoria@amd.com
References: <20210412114433.129702-1-ravi.bangoria@linux.ibm.com>
 <20210412114433.129702-4-ravi.bangoria@linux.ibm.com>
 <YH0M1YdINJqbdqP+@yekko.fritz.box>
 <ca21d852-4b54-01d3-baab-cc8d0d50e505@linux.ibm.com> <YJIyCnVYohsdKLvf@yekko>
From:   Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reply-To: YJIyCnVYohsdKLvf@yekko.fra02v.mail.ibm.com
In-Reply-To: <YJIyCnVYohsdKLvf@yekko>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GH0cxobMMVQVYaXnGAqgR_Uu3zFDWWzt
X-Proofpoint-ORIG-GUID: qKGIMe0_oXr0HA773PwGY1RG_epAtZTm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-07_05,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=699 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1011 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307070078
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_REPLYTO,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David, All,

I am revisiting/reviving this patch.

On 5/5/21 11:20, David Gibson wrote:
> On Wed, Apr 21, 2021 at 11:50:40AM +0530, Ravi Bangoria wrote:
>> Hi David,
>>
>> On 4/19/21 10:23 AM, David Gibson wrote:
>>> On Mon, Apr 12, 2021 at 05:14:33PM +0530, Ravi Bangoria wrote:
>>>
<snip>
> Since we have released versions with POWER10 support, but no DAWR1, in
> theory we need a capability so new qemu with old machine types don't
> gain guest visible features that the same machine types on older qemus
> had.
>
> Except.. there's a loophole we might use to sidestep that.  The
> current POWER10 CPU modelled in qemu is a DD1 - which I strongly
> suspect will never appear outside of IBM.  I'm pretty sure we want to
> replace that with a DD2.
>
> While the modelled CPU is DD1, I think it's pretty reasonable to say
> our POWER10 support hasn't yet stabilized, and it would therefore be
> ok to simply add DAWR1 on POWER10 unconditionally, as long as we do it
> before we switch over to DD2.

As POWER10 DD2 switch over has already happened, the need for

new/separate capability for dawr1 still holds. So, I am keeping it as is.


Posting the next version after rebase.


Thanks,

Shivaprasad

>>> I'm wondering if we're actually just better off setting the pa feature
>>> just based on the guest CPU model.  TCG will be broken if you try to
>>> use it, but then, it already is.  AFAIK there's no inherent reason we
>>> couldn't implement DAWR support in TCG, it's just never been worth the
>>> trouble.
>> Correct. Probably there is no practical usecase for DAWR in TCG mode.
>>
>> Thanks,
>> Ravi
>>
