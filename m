Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45416CDB0D
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 15:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjC2Nmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 09:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2Nmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 09:42:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D6F126;
        Wed, 29 Mar 2023 06:42:44 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TDHFRN031641;
        Wed, 29 Mar 2023 13:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ztl14AJTYvveDaDR6ZiftOrjKUA7hkmEhMEo8dHwKaM=;
 b=iMBmtAL/lbbwUyF20nmzDN9A9ZeAO+tAsGxHpEmt4/sx61cSZZ8I63UvEBDxuKxfgzLw
 lcsIH8uXRRipHFxnBhuA+yOQon/80FZ9kvY8uu8xDNymGqqzv0Kc5WmkcTr20IHPYuVa
 sNsmI2bzPe+lZ7CRZJ1tOgCOf8FmOtKzrvI/2PF1+i2hfkAMHOmR7N5YX37r8/r7jsJz
 KVV9jmhDwjtE2LOwKxveZZP7eteyDFujKFf9vj/xzFFvyC+2Zupl+t1TqMkPZAupvA18
 iIaJWggHc4BcbFgFaAuKdpbD+fE+zPGw89z+n3Z934AZuujfKzHdFUjwXxYH2WVZfKWB Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmp2x0p3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 13:42:43 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32TDcati025720;
        Wed, 29 Mar 2023 13:42:43 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmp2x0p32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 13:42:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32SLQc3G028881;
        Wed, 29 Mar 2023 13:42:40 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3phr7fn1kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 13:42:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32TDgb9033948406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 13:42:37 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 546A420043;
        Wed, 29 Mar 2023 13:42:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06CDF20040;
        Wed, 29 Mar 2023 13:42:37 +0000 (GMT)
Received: from [9.171.75.165] (unknown [9.171.75.165])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 29 Mar 2023 13:42:36 +0000 (GMT)
Message-ID: <0377f8c1-d5d7-04e4-8653-1289d190b955@linux.ibm.com>
Date:   Wed, 29 Mar 2023 15:42:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     thuth@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230327082118.2177-1-nrb@linux.ibm.com>
 <20230327082118.2177-2-nrb@linux.ibm.com>
 <afcf5186-c3f2-d777-be5f-408318039f2d@linux.ibm.com>
 <168009425098.295696.4253423899606982653@t14-nrb>
 <20230329150032.7093e25b@p-imbrenda>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/4] s390x: sie: switch to home space
 mode before entering SIE
In-Reply-To: <20230329150032.7093e25b@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bvmULx-YUqd-Wny9Gh3JYyGVcnPl2rFY
X-Proofpoint-GUID: ogniCBBqj1rJaW38ysSsfYM1Z7SbuNzD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_06,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303290107
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/29/23 15:00, Claudio Imbrenda wrote:
> On Wed, 29 Mar 2023 14:50:50 +0200
> Nico Boehr <nrb@linux.ibm.com> wrote:
> 
>> Quoting Janosch Frank (2023-03-28 16:13:04)
>>> On 3/27/23 10:21, Nico Boehr wrote:
>>>> This is to prepare for running guests without MSO/MSL, which is
>>>> currently not possible.
>>>>
>>>> We already have code in sie64a to setup a guest primary ASCE before
>>>> entering SIE, so we can in theory switch to the page tables which
>>>> translate gpa to hpa.
>>>>
>>>> But the host is running in primary space mode already, so changing the
>>>> primary ASCE before entering SIE will also affect the host's code and
>>>> data.
>>>>
>>>> To make this switch useful, the host should run in a different address
>>>> space mode. Hence, set up and change to home address space mode before
>>>> installing the guest ASCE.
>>>>
>>>> The home space ASCE is just copied over from the primary space ASCE, so
>>>> no functional change is intended, also for tests that want to use
>>>> MSO/MSL. If a test intends to use a different primary space ASCE, it can
>>>> now just set the guest.asce in the save_area.
>>>>    
>>> [...]
>>>> +     /* set up home address space to match primary space */
>>>> +     old_cr13 = stctg(13);
>>>> +     lctlg(13, stctg(1));
>>>> +
>>>> +     /* switch to home space so guest tables can be different from host */
>>>> +     psw_mask_set_bits(PSW_MASK_HOME);
>>>> +
>>>> +     /* also handle all interruptions in home space while in SIE */
>>>> +     lowcore.pgm_new_psw.mask |= PSW_MASK_DAT_HOME;
>>>    
>>>> +     lowcore.ext_new_psw.mask |= PSW_MASK_DAT_HOME;
>>>> +     lowcore.io_new_psw.mask |= PSW_MASK_DAT_HOME;
>>> We didn't enable DAT in these two cases as far as I can see so this is
>>> superfluous or we should change the mmu code. Also it's missing the svc
>>> and machine check.
>>
>> Right. Is there a particular reason why we only run DAT on for PGM ints?
> 
> a fixup handler for PGM it might need to run with DAT on (e.g. to
> access data that is not identity mapped), whereas for other interrupts
> it's not needed (at least not yet ;) )

At the time where the mmu code was written, the other handlers were very 
basic or a direct abort (like the IO IRQ that was introduced by Pierre). 
But I'd rather have them all behave the same so they are at least 
consistent.

If we don't introduce a location where we load the PSW from, then add a 
function that sets the masks for all IRQs and also convert the mmu 
enablement to use it.

Something to the likes of:

void irq_new_set_mask(bool dat, uint8_t as)
{
	loop over psws {
		- Remove dat and as bits from new PSW
		- Or in the new dat + as bits
	}
}
