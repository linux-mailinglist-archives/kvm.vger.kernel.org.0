Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49546F5BC7
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 18:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjECQLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 12:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjECQLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 12:11:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F3D72BE
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 09:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683130215;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iHAjsHAaaqgyjPtfZLNpavdoVBdm9qokwL/9JsrOAiI=;
        b=HUkxg3vMIGYweZUebdoesBl3BsNrOfQmGejU2Qtun7vl0/89qDaxiyKPFsEOWCshqs82cc
        4c8JVNqj6wTMhCRXXjKfF7ORWX2X2+B6fC7pH5dtzuwCtNrARBCR0nNra4Q4JAyVCLyviv
        KZsuYea/bspdRVzdP3cN0pn0C9qpUcE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-Yt2oAUdKP3qdZkpW9JOVmQ-1; Wed, 03 May 2023 12:10:12 -0400
X-MC-Unique: Yt2oAUdKP3qdZkpW9JOVmQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6074858F09;
        Wed,  3 May 2023 16:10:11 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D158492C3E;
        Wed,  3 May 2023 16:10:08 +0000 (UTC)
Date:   Wed, 3 May 2023 17:10:01 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Dionna Amalie Glaze <dionnaglaze@google.com>
Cc:     =?utf-8?B?SsO2cmcgUsO2ZGVs?= <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Klaus Kiwi <kkiwi@redhat.com>, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org, amd-sev-snp@lists.suse.com
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZFKHWf5A8APB/XEe@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <ZBl4592947wC7WKI@suse.de>
 <4420d7e5-d05f-8c31-a0f2-587ebb7eaa20@amd.com>
 <ZFJTDtMK0QqXK5+E@suse.de>
 <CAAH4kHa_mWSVrOdp-XvV9kd0fULQ_OOf4j8TMWJy6GhoZD5SEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAH4kHa_mWSVrOdp-XvV9kd0fULQ_OOf4j8TMWJy6GhoZD5SEg@mail.gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 03, 2023 at 08:24:10AM -0700, Dionna Amalie Glaze wrote:
> On Wed, May 3, 2023 at 5:27 AM Jörg Rödel <jroedel@suse.de> wrote:
> > >   - On the subject of priorities, the number one priority for the
> > >     linux-svsm project has been to quickly achieve production quality vTPM
> > >     support. The support for this is being actively worked on by
> > >     linux-svsm contributors and we'd want to find fastest path towards
> > >     getting that redirected into coconut-svsm (possibly starting with CPL0
> > >     implementation until CPL3 support is available) and the project
> > >     hardened for a release.  I imagine there will be some competing
> > >     priorities from coconut-svsm project currently, so wanted to get this
> > >     out on the table from the beginning.
> >
> > That has been under discussion for some time, and honestly I think
> > the approach taken is the main difference between linux-svsm and
> > COCONUT. My position here is, and that comes with a big 'BUT', that I am
> > not fundamentally opposed to having a temporary solution for the TPM
> > until CPL-3 support is at a point where it can run a TPM module.
> >
> > And here come the 'BUT': Since the goal of having one project is to
> > bundle community efforts, I think that the joint efforts are better
> > targeted at getting CPL-3 support to a point where it can run modules.
> > On that side some input and help is needed, especially to define the
> > syscall interface so that it suits the needs of a TPM implementation.
> >
> > It is also not the case that CPL-3 support is out more than a year or
> > so. The RamFS is almost ready, as is the archive file inclusion[1]. We
> > will move to task management next, the goal is still to have basic
> > support ready in 2H2023.
> >
> > [1] https://github.com/coconut-svsm/svsm/pull/27
> >
> > If there is still a strong desire to have COCONUT with a TPM (running at
> > CPL-0) before CPL-3 support is usable, then I can live with including
> > code for that as a temporary solution. But linking huge amounts of C
> > code (like openssl or a tpm lib) into the SVSM rust binary kind of
> > contradicts the goals which made us using Rust for project in the first
> > place. That is why I only see this as a temporary solution.
> >
> > > Since we don't want to split resources or have competing projects, we are
> > > leaning towards moving our development resources over to the coconut-svsm
> > > project.
> >
> 
> Not to throw a wrench in the works, but is it possible for us to have
> an RTMR protocol as a stop-gap between a fully paravirtualized vTPM
> and a fully internalized vTPM? The EFI protocol
> CC_MEASUREMENT_PROTOCOL is already standardized, and it can serve as a
> hardware-rooted integrity measure for a paravirtualized vTPM. This
> solution would further allow a TDX measured boot solution to be more
> thoroughly supported earlier, given that we'd need to have the RTMR
> event log replay logic implemented.

IMHO it would be preferrable if RTMR was exposed to as little as possible.
The less special cases we have to build into applications / projects
related to confidential virt, the better off we'll be. The use of industry
standard TPMs with PCRs reduces the matrix that work that is needed to
support confidential virt across the stack.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

