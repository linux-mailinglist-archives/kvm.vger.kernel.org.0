Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9263A506D85
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 15:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244226AbiDSNgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 09:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243962AbiDSNgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 09:36:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A2882252A
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 06:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650375205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Q1ZKb2vhm6xzFB6dH4S0BphbsICw4w11AsX7JXEyf0=;
        b=F/qpDkwWYl95Jj79cY3FrZ6G/vy75MaDSsnEcKM0J18vqIx6GbCAxAdOap9gP332gLIbXC
        RiTbWOeosVBwBcBXJqSMNdXYpmmmb8CElG46k/hqxdKjINqkE3V2U33F6t9qkkviJX2wos
        urC+bBMcmzG1HwPqjbyo8PVj58yL3tU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-ZMIdkErAO2yUJ32DJEJPxQ-1; Tue, 19 Apr 2022 09:33:22 -0400
X-MC-Unique: ZMIdkErAO2yUJ32DJEJPxQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8A683804500;
        Tue, 19 Apr 2022 13:33:21 +0000 (UTC)
Received: from [10.22.8.117] (unknown [10.22.8.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75D777C28;
        Tue, 19 Apr 2022 13:33:21 +0000 (UTC)
Message-ID: <ac2bc657-947b-e528-791b-101447e074d8@redhat.com>
Date:   Tue, 19 Apr 2022 09:33:21 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: adding 'official' way to dump SEV VMSA
Content-Language: en-US
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <a713533d-c4c5-2237-58d0-57b812a56ba4@redhat.com>
 <462cbf77-432a-c09c-6ec9-91556dc0f887@linux.ibm.com>
 <YlfakQfkZFOpKWeU@work-vm>
From:   Cole Robinson <crobinso@redhat.com>
In-Reply-To: <YlfakQfkZFOpKWeU@work-vm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/22 4:25 AM, Dr. David Alan Gilbert wrote:
> * Dov Murik (dovmurik@linux.ibm.com) wrote:
>> Hi Cole,
>>
>> On 13/04/2022 16:36, Cole Robinson wrote:
>>> Hi all,
>>>
>>> SEV-ES and SEV-SNP attestation require a copy of the initial VMSA to
>>> validate the launch measurement. For developers dipping their toe into
>>> SEV-* work, the easiest way to get sample VMSA data for their machine is
>>> to grab it from a running VM.
>>>
>>> There's two techniques I've seen for that: patch some printing into
>>> kernel __sev_launch_update_vmsa, or use systemtap like danpb's script
>>> here: https://gitlab.com/berrange/libvirt/-/blob/lgtm/scripts/sev-vmsa.stp
>>>
>>> Seems like this could be friendlier though. I'd like to work on this if
>>> others agree.
>>>
>>> Some ideas I've seen mentioned in passing:
>>>
>>> - debugfs entry in /sys/kernel/debug/kvm/.../vcpuX/
>>> - new KVM ioctl
>>> - something with tracepoints
>>> - some kind of dump in dmesg that doesn't require a patch
>>>
>>> Thoughts?
>>
>>
>> Brijesh suggested to me to construct the VMSA without getting any info from
>> the host (except number of vcpus), because the initial state of the vcpus
>> is standard and known if you use QEMU and OVMF (but that's open for discussion).
>>
>> I took his approach (thanks Brijesh!) and now it's how we calculate expected
>> SNP measurements in sev-snp-measure [1].  The relevant part for VMSA construction
>> is in [2].
>>
>> I plan to add SEV-ES and SEV measurements calculation to this 
>> library/program as well.
> 
> Everyone seems to be writing one; you, Dan etc!
> 

Yeah, I should have mentioned Dan's demo tool here:
https://gitlab.com/berrange/libvirt/-/blob/lgtm/tools/virt-dom-sev-vmsa-tool.py

Tyler Fanelli is looking at adding that functionality to sevctl too FWIW

> I think I agree the right way is to build it programmatically rather
> than taking a copy from the kernel;  it's fairly simple, although the
> scripts get increasingly hairy as you deal with more and more VMM's and
> firmwares.
> 

Agreed. A nice way to dump VMSA from the kernel will be useful for
debugging, or extending these scripts to support different VMMs.

> I think I'd like to see a new ioctl to read the initial VMSA, primarily
> as a way of debugging so you can see what VMSA you have when something
> goes wrong.
> 

debugfs seems simpler for the dev user (accessing a file per CPU vs code
to call ioctl), but beyond that I don't have any insight. Is there a
reason you think ioctl and not debugfs?

Thanks,
Cole

