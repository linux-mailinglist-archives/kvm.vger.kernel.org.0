Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E5F293822
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 11:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392927AbgJTJgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 05:36:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391793AbgJTJgg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 05:36:36 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09K9XZtl125605;
        Tue, 20 Oct 2020 05:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=IE4tSXNgZJ/A/OkRNfld13XIrViGk4gj+u3fpAw7zwQ=;
 b=pA5FpX/SYFNG/j4PAa+nQoVumZiyGb3JF90uyEIknSgtd12LVxc04HsJI9owM/yssY5r
 FjKCGGXswJSADXtQhevOFhsag0y+6qhwG7rA0L1AA7/x6kzLfOzbp77Kd/dTjqmI3xa6
 GIkg4ISNyPriW1nYiPSlQO8JsDe5ysRFgavViGKLjd9jN3shFUq1pbTNNKng6/1yP9lP
 p4BGaYoYZ+StGxPgu1VxDCACzmY5L3BpN5nRhEhU25EH7SRFelnVkXVYdX6OQt80B3EZ
 gtnXDjCT2EBSFzk/wxtQSB41XU6HNDr4sGRekg2HbZcNiUCSBhRMKdNw6Ja/r3V8pgdl kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 349vw0h2rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Oct 2020 05:35:43 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09K9Xh4u126306;
        Tue, 20 Oct 2020 05:35:42 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 349vw0h2p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Oct 2020 05:35:42 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09K9RkDC007087;
        Tue, 20 Oct 2020 09:35:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 347qvhb2hf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Oct 2020 09:35:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09K9ZbfV27001324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Oct 2020 09:35:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E3DD11C04A;
        Tue, 20 Oct 2020 09:35:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEF2C11C050;
        Tue, 20 Oct 2020 09:35:35 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.169.37])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Oct 2020 09:35:35 +0000 (GMT)
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
To:     Alexander Graf <graf@amazon.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>
Cc:     Willy Tarreau <w@1wt.eu>, Colm MacCarthaigh <colmmacc@amazon.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "open list:VIRTIO GPU DRIVER" 
        <virtualization@lists.linux-foundation.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>, bonzini@gnu.org,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, oridgar@gmail.com,
        ghammer@redhat.com, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>, mpe@ellerman.id.au,
        linux-s390 <linux-s390@vger.kernel.org>
References: <788878CE-2578-4991-A5A6-669DCABAC2F2@amazon.com>
 <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com>
 <20201017033606.GA14014@1wt.eu>
 <CAG48ez0x2S9XuCrANAQbXNi8Jjwm822-fnQSmr-Zr07JgrEs1g@mail.gmail.com>
 <6CC3DB03-27BA-4F5E-8ADA-BE605D83A85C@amazon.com>
 <CAG48ez1ZtvjOs2CEq8-EMosPCd_o7WQ3Mz_+1mDe7OrH2arxFA@mail.gmail.com>
 <20201017053712.GA14105@1wt.eu>
 <CAG48ez1h0ynXfGap_KiHiPVTfcB8NBQJ-2dnj08ZNfuhrW0jWA@mail.gmail.com>
 <20201017064442.GA14117@1wt.eu>
 <CAG48ez3pXLC+eqAXDCniM0a+5yP2XJODDkZqiUTZUOttCE_LbA@mail.gmail.com>
 <CAHmME9qHGSF8w3DoyCP+ud_N0MAJ5_8zsUWx=rxQB1mFnGcu9w@mail.gmail.com>
 <aacdff7a-2af1-4f46-6ab2-2a9d5b865d35@amazon.de>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Message-ID: <2e505365-db4a-6054-8bc8-f9a81978c6d4@de.ibm.com>
Date:   Tue, 20 Oct 2020 11:35:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <aacdff7a-2af1-4f46-6ab2-2a9d5b865d35@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-20_04:2020-10-20,2020-10-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1011 malwarescore=0 impostorscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010200064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17.10.20 20:09, Alexander Graf wrote:
> Hi Jason,
> 
> On 17.10.20 15:24, Jason A. Donenfeld wrote:
>>
>> After discussing this offline with Jann a bit, I have a few general
>> comments on the design of this.
>>
>> First, the UUID communicated by the hypervisor should be consumed by
>> the kernel -- added as another input to the rng -- and then userspace
> 
> We definitely want a kernel internal notifier as well, yes :).
> 
>> should be notified that it should reseed any userspace RNGs that it
>> may have, without actually communicating that UUID to userspace. IOW,
> 
> I also tend to agree that it makes sense to disconnect the actual UUID we receive from the notification to user space. This would allow us to create a generic mechanism for VM save/restore cycles across different hypervisors. Let me add PPC and s390x people to the CC list to see whether they have anything remotely similar to the VmGenID mechanism. For x86 and aarch64, the ACPI and memory based VmGenID implemented here is the most obvious option to implement IMHO. It's also already implemented in all major hypervisors.

Hmm, what we do have configurations (e.g. stfle bits) and we do have a notification mechanism via sclp that notifies guests when things change.
As of today neither KVM nor Linux implement the sclp change notification mechanism, but I do see value in such a thing.

> 
>> I agree with Jann there. Then, it's the functioning of this
>> notification mechanism to userspace that is interesting to me.
> 
> Absolutely! Please have a look at the previous discussion here:
> 
> 
> https://lore.kernel.org/linux-pm/B7793B7A-3660-4769-9B9A-FFCF250728BB@amazon.com/
> 
> The user space interface is absolutely what this is about.

Yes. Passing a notification to userspace is essential. Where I do not see a solution yet is the race between notification and
already running with the old knowledge.
> 
>> There are a few design goals of notifying userspace: it should be
>> fast, because people who are using userspace RNGs are usually doing so
>> in the first place to completely avoid syscall overhead for whatever
>> high performance application they have - e.g. I recall conversations
>> with Colm about his TLS implementation needing to make random IVs
>> _really_ fast. It should also happen as early as possible, with no
>> race or as minimal as possible race window, so that userspace doesn't
>> begin using old randomness and then switch over after the damage is
>> already done.
> 
> There are multiple facets and different types of consumers here. For a user space RNG, I agree that fast and as race free as possible is key. That's what the mmap interface is there for.
> 
> There are applications way beyond that though. What do you do with applications that already consumed randomness? For example a cached pool of SSL keys. Or a higher level language primitive that consumes randomness and caches its seed somewhere in an internal data structure. Or even worse: your system's host ssh key.
> 
> For those types of events, an mmap (or vDSO) interface does not work. We need to actively allow user space applications to readjust to the new environment - either internally (the language primitive case) or through a system event, maybe even as systemd trigger (the ssh host key case).
> 
> To give everyone enough time before we consider a system as "updated to the new environment", we have the callback logic with the "Orchestrator" that can check whether all listeners to system wide updates confirms they adjusted themselves.
> 
> That's what the rest of the logic is there for: A read+poll interface and all of the orchestration logic. It's not for the user space RNG case, it's for all of its downstream users.
> 
>> I'm also not wedded to using Microsoft's proprietary hypervisor design
>> for this. If we come up with a better interface, I don't think it's
>> asking too much to implement that and reasonably expect for Microsoft
>> to catch up. Maybe someone here will find that controversial, but
>> whatever -- discussing ideal designs does not seem out of place or
>> inappropriate for how we usually approach things in the kernel, and a
>> closed source hypervisor coming along shouldn't disrupt that.
> 
> The main bonus point on this interface is that Hyper-V, VMware and QEMU implement it already. It would be a very natural for into the ecosystem. I agree though that we shouldn't have our user space interface necessarily dictated by it: Other hypervisors may implement different ways such as a simple edge IRQ that gets triggered whenever the VM gets resumed.
> 
>> So, anyway, here are a few options with some pros and cons for the
>> kernel notifying userspace that its RNG should reseed.
> 
> I can only stress again that we should not be laser focused on the RNG case. In a lot of cases, data has already been generated by the RNG before the snapshot and needs to be reinitialized after the snapshot. In other cases such as system UUIDs, it's completely orthogonal to the RNG.
> 
>>
>> 1. SIGRND - a new signal. Lol.
> 
> Doable, but a lot of plumbing in user space. It's also not necessarily a good for for event notification in most user space applications.
> 
>>
>> 2. Userspace opens a file descriptor that it can epoll on. Pros are
>> that many notification mechanisms already use this. Cons is that this
>> requires syscall and might be more racy than we want. Another con is
>> that this a new thing for userspace programs to do.
> 
> That's part of what this patch does, right? This patch implements read+poll as well as mmap() for high speed reads.
> 
>> 3. We stick an atomic counter in the vDSO, Jann's suggestion. Pros are
>> that this is extremely fast, and also simple to use and implement.
>> There are enough sequence points in typical crypto programs that
>> checking to see whether this counter has changed before doing whatever
>> operation seems easy enough. Cons are that typically we've been
>> conservative about adding things to the vDSO, and this is also a new
>> thing for userspace programs to do.
> 
> The big con is that its use is going to be super limited to applications that can be adapted to check their "vm generation" through a vDSO call / read every time they consume data that may potentially need to be regenerated.
> 
> This probably works for the pure RNG case. It falls apart for more sophisticated things such as "redo my ssh host keys and restart the service" or "regenerate my samba machine uuid".
> 
>> 4. We already have a mechanism for this kind of thing, because the
>> same issue comes up when fork()ing. The solution was MADV_WIPEONFORK,
>> where userspace marks a page to be zeroed when forking, for the
>> purposes of the RNG being notified when its world gets split in two.
>> This is basically the same thing as we're discussing here with guest
>> snapshots, except it's on the system level rather than the process
>> level, and a system has many processes. But the problem space is still
>> almost the same, and we could simply reuse that same mechanism. There
>> are a few implementation strategies for that:
> 
> Yup, that's where we started from :). And then we ran into resistance by the mm people (on CC here). And then we looked at the problem more in depth and checked what it would take to for example implement this for user space RNGs in Java. It's ... more complicated than one may think at first.
> 
>> 4a. We mess with the PTEs of all processes' pages that are
>> MADV_WIPEONFORK, like fork does now, when the hypervisor notifies us
>> to do so. Then we wind up reusing the already existing logic for
>> userspace RNGs. Cons might be that this usually requires semaphores,
>> and we're in irq context, so we'd have to hoist to a workqueue, which
>> means either more wake up latency, or a larger race window.
>>
>> 4b. We just memzero all processes' pages that are MADV_WIPEONFORK,
>> when the hypervisor notifies us to do so. Then we wind up reusing the
>> already existing logic for userspace RNGs.
>>
>> 4c. The guest kernel maintains an array of physical addresses that are
>> MADV_WIPEONFORK. The hypervisor knows about this array and its
>> location through whatever protocol, and before resuming a
>> moved/snapshotted/duplicated VM, it takes the responsibility for
>> memzeroing this memory. The huge pro here would be that this
>> eliminates all races, and reduces complexity quite a bit, because the
>> hypervisor can perfectly synchronize its bringup (and SMP bringup)
>> with this, and it can even optimize things like on-disk memory
>> snapshots to simply not write out those pages to disk.
>>
>> A 4c-like approach seems like it'd be a lot of bang for the buck -- we
>> reuse the existing mechanism (MADV_WIPEONFORK), so there's no new
>> userspace API to deal with, and it'd be race free, and eliminate a lot
>> of kernel complexity.
>>
>> But 4b and 3 don't seem too bad either.
>>
>> Any thoughts on 4c? Is that utterly insane, or does that actually get
>> us somewhere close to what we want?
> 
> All of the options for "4" are possible and have an RFC out. Please check out the discussion linked above :).
> 
> The problem with anything that relies on close loop reads (options 3+4) is not going to work well with the more sophisticated use case of derived data.
> 
> IMHO it will boil down to "both". We will need a high-speed interface that with close-to-0 overhead tells you either the generation ID or clears pages (options 3+4) as well as something that is bigger for applications that can either intrinsically (sshd) or by system design (Java) not adopt the mechanisms above easily.
> 
> That said, we need to start somewhere. I don't mind which angle we start from. But this is a real world problem and one that will only become more prevalent over time as VMs are used for more than only your traditional enterprise hardware consolidation.
> 
> 
> Alex
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 
