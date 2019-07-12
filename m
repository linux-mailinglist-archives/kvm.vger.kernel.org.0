Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD12666848
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 10:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfGLILR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 04:11:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42150 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfGLILR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 04:11:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6C896rx002321;
        Fri, 12 Jul 2019 08:09:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=2tqEcmeLMeBgU3gGieUNuwSnxjbrQ/jmkTtByRX3RIE=;
 b=DvsaEaFNL7mXZf4t8TbD1WICbedvS6gXnuNWRU6+EhUI9XdmryDQbk9oboMU6PwhEa/d
 28l5JpbAOTVmdiUJOo0kUEkSZwQzVV5A/3elCDczMiD1LMVgxz2Cl70jq+95JaCFwmiY
 88y+spRDwcQsEhg4fXreM4bRNOTFII/2UECL515bHyVQ3scJP53TAix2Uv+9ajtzU2K3
 6ScCbuMVR79YPhRS6tYss1/BMcLK9e6XvckJpnixvGoXnD57Nx/yYHQkBFsaE2wxsNK6
 UEU7tyMVp2A3mqIqhf+iNdFA2/297k2DBHX65Vvl76VGG0Wdz45MCDDoPXqJby5YEEDh KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2tjk2u47nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 08:09:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6C87a4X087501;
        Fri, 12 Jul 2019 08:09:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2tmwgyn6kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 08:09:58 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6C89tfH027689;
        Fri, 12 Jul 2019 08:09:56 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Jul 2019 01:09:55 -0700
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
To:     Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <2791712a-9f7b-18bc-e686-653181461428@oracle.com>
Date:   Fri, 12 Jul 2019 10:09:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120085
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/12/19 12:38 AM, Dave Hansen wrote:
> On 7/11/19 7:25 AM, Alexandre Chartre wrote:
>> - Kernel code mapped to the ASI page-table has been reduced to:
>>    . the entire kernel (I still need to test with only the kernel text)
>>    . the cpu entry area (because we need the GDT to be mapped)
>>    . the cpu ASI session (for managing ASI)
>>    . the current stack
>>
>> - Optionally, an ASI can request the following kernel mapping to be added:
>>    . the stack canary
>>    . the cpu offsets (this_cpu_off)
>>    . the current task
>>    . RCU data (rcu_data)
>>    . CPU HW events (cpu_hw_events).
> 
> I don't see the per-cpu areas in here.  But, the ASI macros in
> entry_64.S (and asi_start_abort()) use per-cpu data.

We don't map all per-cpu areas, but only the per-cpu variables we need. ASI
code uses the per-cpu cpu_asi_session variable which is mapped when an ASI
is created (see patch 15/26):

+	/*
+	 * Map the percpu ASI sessions. This is used by interrupt handlers
+	 * to figure out if we have entered isolation and switch back to
+	 * the kernel address space.
+	 */
+	err = ASI_MAP_CPUVAR(asi, cpu_asi_session);
+	if (err)
+		return err;


> Also, this stuff seems to do naughty stuff (calling C code, touching
> per-cpu data) before the PTI CR3 writes have been done.  But, I don't
> see anything excluding PTI and this code from coexisting.

My understanding is that PTI CR3 writes only happens when switching to/from
userland. While ASI enter/exit/abort happens while we are already in the kernel,
so asi_start_abort() is not called when coming from userland and so not
interacting with PTI.

For example, if ASI in used during a syscall (e.g. with KVM), we have:

  -> syscall
     - PTI CR3 write (kernel CR3)
     - syscall handler:
       ...
       asi_enter()-> write ASI CR3
       .. code run with ASI ..
       asi_exit() or asi abort -> restore original CR3
       ...
     - PTI CR3 write (userland CR3)
  <- syscall


Thanks,

alex.
