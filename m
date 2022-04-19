Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABC55075FE
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 19:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352578AbiDSRIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 13:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355627AbiDSRHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 13:07:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A04612098
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 10:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650387896;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=jyS3S/OuVOGopfcMbZcoACsR9LqN55BST7IaWHrVFtY=;
        b=X3df6MZ8l1AsZy+z8up8SBvWuY7bFHsWIETOp9h0ptoSrXLXFw5muNuk5TOc1nojHt348R
        jhmZFu6alQR7iZfS+Nx60MpLuwWzfF26NwOIortZJb/uu6+3iqGAzDEt85a40qsQymHfRS
        nZUn8yPaRkUU2bnn7YpICdpq8p2ujEs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-TrnO4P0iODOcW83pj5ZhzA-1; Tue, 19 Apr 2022 13:04:52 -0400
X-MC-Unique: TrnO4P0iODOcW83pj5ZhzA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F79A802803;
        Tue, 19 Apr 2022 17:04:52 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1091340CF8FA;
        Tue, 19 Apr 2022 17:04:50 +0000 (UTC)
Date:   Tue, 19 Apr 2022 18:04:48 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Cole Robinson <crobinso@redhat.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: adding 'official' way to dump SEV VMSA
Message-ID: <Yl7rsJvqiUE+IbuF@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <a713533d-c4c5-2237-58d0-57b812a56ba4@redhat.com>
 <462cbf77-432a-c09c-6ec9-91556dc0f887@linux.ibm.com>
 <YlfakQfkZFOpKWeU@work-vm>
 <ac2bc657-947b-e528-791b-101447e074d8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ac2bc657-947b-e528-791b-101447e074d8@redhat.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 19, 2022 at 09:33:21AM -0400, Cole Robinson wrote:
> On 4/14/22 4:25 AM, Dr. David Alan Gilbert wrote:
> > * Dov Murik (dovmurik@linux.ibm.com) wrote:
> >> I plan to add SEV-ES and SEV measurements calculation to this 
> >> library/program as well.
> > 
> > Everyone seems to be writing one; you, Dan etc!
> > 
> 
> Yeah, I should have mentioned Dan's demo tool here:
> https://gitlab.com/berrange/libvirt/-/blob/lgtm/tools/virt-dom-sev-vmsa-tool.py

FYI a bit of explanation of that tool...

Some complications wrt VMSA contents in no particular order

  - VMSA contents can vary across firmwares due to reset address
  - No current supportable way to extract VMSA from kernel
  - VMSA varies across userspace QEMU vs libkrun
  - VMSA varies across CPU due to include model/family/stepping

The last point in particular is a big pain, becasue it means that there
are going to be a great many valid VMSA blobs.

Thus I put some time into working on the above tool to build VMSA from
first principles. ie populating register defaults based on the AMD tech
specs for x86/sev, along with examination on what KVM/QEMU does to override
the defaults in places.

The tool does three simple things...

Create a generic VMSA for CPU 0 for QEMU:

  $ virt-dom-sev-vmsa-tool.py build --cpu 0 --userspace qemu  cpu0.bin

Update the generic VMSA with firmware and CPU details
  $ virt-dom-sev-vmsa-tool.py update \
       --firmware OVMF.amdsev.fd \
       --model 49 --family 23 --stepping 0  cpu0.bin


Note, I split this as I felt it might be interesting for a cloud provider
to publish a known "generic" VMSA, and then let it be customized per boot
depending on what CPU model/family the VM ran on, and/or what firmware
it was booted with. The 'build' command can directly set the firmware
and cpu model/family though, if all-in-one is sufficient.

Display the VMSA register info, skipping fields which are all zero

  $ virt-dom-sev-vmsa-tool.py show --zeroes skip cpu0.bin
es_attrib           : 0x0093 (10010011 00000000)
es_limit            : 0x0000ffff
cs_selector         : 0xf000
cs_attrib           : 0x009b (10011011 00000000)
cs_limit            : 0x0000ffff
cs_base             : 0x00000000ffff0000
ss_attrib           : 0x0093 (10010011 00000000)
ss_limit            : 0x0000ffff
ds_attrib           : 0x0093 (10010011 00000000)
ds_limit            : 0x0000ffff
fs_attrib           : 0x0093 (10010011 00000000)
fs_limit            : 0x0000ffff
gs_attrib           : 0x0093 (10010011 00000000)
gs_limit            : 0x0000ffff
gdtr_limit          : 0x0000ffff
ldtr_attrib         : 0x0082 (10000010 00000000)
ldtr_limit          : 0x0000ffff
idtr_limit          : 0x0000ffff
tr_attrib           : 0x008b (10001011 00000000)
tr_limit            : 0x0000ffff
efer                : 0x0000000000001000
cr4                 : 0x0000000000000040
cr0                 : 0x0000000000000010
dr7                 : 0x0000000000000400
dr6                 : 0x00000000ffff0ff0
rflags              : 0x0000000000000002
rip                 : 0x000000000000fff0
g_pat               : 0x0007040600070406
rdx                 : 0x0000000000830f10 (00010000 00001111 10000011 00000000 00000000 00000000 00000000 00000000)
xcr0                : 0x0000000000000001


The 'show' command is largely a debugging tool, so you can understand what
unexpectedly changed if you're failing to get a valid match.

If you look at the code, you can see comments on where I found the various
default values. I'm fairly confident about the QEMU source, but I am not
happy with my info sources for libkrun but then I didn't spend much time
exploring its code. Anyway, it can at least spit out a vmsa that matches
what is committed in libkrun's git repo.

I'm not in love with this particular impl of the tool. I wrote it to be
quick & easy, to prove the viability of a 'build from specs' approach
to VMSA. I find this the most satisfactory way out of all the options
we've considered so far. The need for a different VMSA per cpu
family/model/stepping in particular, makes me feel we need a tool like
this, as just publishing known good VMSA is not viable with so many
combinations possible.

> Tyler Fanelli is looking at adding that functionality to sevctl too FWIW

Yes, I think this functionality belongs in sev / sevctl, rather than
my python script, so I'm not intended to submit my python program as
an official solution for anything. It is just there as a historical
curiosity at this point, until sevctl can do the same.

> > I think I'd like to see a new ioctl to read the initial VMSA, primarily
> > as a way of debugging so you can see what VMSA you have when something
> > goes wrong.
> > 
> 
> debugfs seems simpler for the dev user (accessing a file per CPU vs code
> to call ioctl), but beyond that I don't have any insight. Is there a
> reason you think ioctl and not debugfs?

A debugfs entry could be useful for automated data collection tools.
eg sosreport could capture a debugfs file easily for a running VM,
where as using an ioctl will require special code to be written for
sosreport.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

