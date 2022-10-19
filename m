Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD0460516F
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 22:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiJSUlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 16:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiJSUlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 16:41:05 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC9614EC4F
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 13:41:03 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bj12so42687269ejb.13
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 13:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=joCEkh4xuAKfbwjroBgzhwFYeKLC3Rr/Phk5mK3CEIs=;
        b=ljKjEQ6/LXrjOB//YoMH8wFykC0d2vUdow7fzGBEOiWXBe+MBrIfmNuj07kqijMQyS
         wiI/xaxludaEc225qycRkhZLKfKADBCZEAmv006++mXtnihdL9Q5rWZ1ipk5canlzZhs
         p4X0kwmlEX3nJ6gLsAIWVASWXbPaaEEovAQc59P9W6oFJat0H7ogfYgIXH5DCQVV1fEd
         lmT6ieDJftmrkPAnu4EJUnenP6VhowAI08zR43MweoQ6eD6I5RuqqGCwsmczmW+StIcl
         MFKWuJy0S3QjrvQpfrbsf/YjcBzm7Sga70vmcjv0Nt8Qx2Gs/11rIOMHh6TRhW3fiJJf
         NQdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=joCEkh4xuAKfbwjroBgzhwFYeKLC3Rr/Phk5mK3CEIs=;
        b=eQOl7VKh0wJqaRv3m9o1iGjI7XvUSdfrQGOcsi0wYpkkGZ4xdyUpar03EaEVmpcEpA
         62YKvX5u3LzzIZU+MtB3ODbydX/zMLBAGblcOrZE8aubF7CMYIX38+luUPW0LDUwH5T5
         SEJjaT7OupjfXL1E7oawwzhow0nEdKd5q7OTwlG3QX/kxDUTHS1b4XH1aKweUVh1Thoy
         Hg3cKDAtJLd5+HODmB9vI8D6vNytUp37omy3hZ1JR5uFDGke4As3Dxc6KCnEj1dFG0l0
         KcCP5s884MovkPPMqXMhjSe3NKc2R2OrGwXcGdHE6n4K0NI+kHpn2EkDg8a94L/dQcU9
         f8Lw==
X-Gm-Message-State: ACrzQf3ozcrKO++dSf5mtNwxRVDTpHgSw9Evo0tzXEpikJLQDSVYhhDr
        pJ653rxf5bhmMIj/ZPOgI8wSeDmT+Vnu2V+PUjg0Bg==
X-Google-Smtp-Source: AMsMyM4QJOcZTviY2WRyiIf1MzRpYndp0olLr4BgKpndmfz6QaTNGv4T7TznqWveDKh7ibH/2J+XYgRPI/lMgzv9j04=
X-Received: by 2002:a17:907:628f:b0:72f:58fc:3815 with SMTP id
 nd15-20020a170907628f00b0072f58fc3815mr8424634ejc.719.1666212061665; Wed, 19
 Oct 2022 13:41:01 -0700 (PDT)
MIME-Version: 1.0
References: <20221019150333.1047423-1-pgonda@google.com> <528937ab-8046-d5d1-26ff-50ef35f5635f@amd.com>
 <CAMkAt6ritG1zmOreh9WYLYAGww0EJQy+m-Y0nfxD5+gpTkpJ1w@mail.gmail.com>
 <821e750b-26c9-3331-7577-5cb832a35afa@amd.com> <CAAH4kHYhLkiN7H03GKgMU+3h9rhp2a03gNFGLbrNtjp=PYYHQw@mail.gmail.com>
 <5621c2b6-a5eb-c786-afee-020e97c0e4c8@amd.com>
In-Reply-To: <5621c2b6-a5eb-c786-afee-020e97c0e4c8@amd.com>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Wed, 19 Oct 2022 13:40:50 -0700
Message-ID: <CAAH4kHYnfQF6fweNQixQnjA95Os9RBvoAhFk6CPtOZmnA0+-9w@mail.gmail.com>
Subject: Re: [PATCH] virt: Prevent AES-GCM IV reuse in SNP guest driver
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@suse.de>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022 at 12:56 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 10/19/22 14:17, Dionna Amalie Glaze wrote:
> > On Wed, Oct 19, 2022 at 11:44 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> >>
> >> On 10/19/22 12:40, Peter Gonda wrote:
> >>> On Wed, Oct 19, 2022 at 11:03 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> >>>>
> >>>> On 10/19/22 10:03, Peter Gonda wrote:
> >>>>> The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
> >>>>> communicate securely with each other. The IV to this scheme is a
> >>>>> sequence number that both the ASP and the guest track. Currently this
> >>>>> sequence number in a guest request must exactly match the sequence
> >>>>> number tracked by the ASP. This means that if the guest sees an error
> >>>>> from the host during a request it can only retry that exact request or
> >>>>> disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
> >>>>> reuse see:
> >>>>> https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf
> >>>>
> >>
> >> I think I've wrapped my head around this now. Any non-zero return code
> >> from the hypervisor for an SNP Guest Request is either a hypervisor error
> >> or an sev-guest driver error, and so the VMPCK should be disabled. The
> >> sev-guest driver is really doing everything (message headers, performing
> >> the encryption, etc.) and is only using userspace data that will be part
> >> of the response message and can't result in a non-zero hypervisor return code.
> >>
> >> For the SNP Extended Guest Request, we only need to special case a return
> >> code of SNP_GUEST_REQ_INVALID_LEN. See below for my responses on that.
> >>
> >>
> >>>> I wonder if we can at least still support the extended report length query
> >>>> by having the kernel allocate the required pages when the error is
> >>>> SNP_GUEST_REQ_INVALID_LEN and retry the exact request again. If there are
> >>>> no errors on the second request, the sequence numbers can be safely
> >>>> updated, but the kernel returns the original error (which will provide the
> >>>> caller with the number of pages required).
> >>>
> >>> I think we can but I thought fixing the security bug could come first,
> >>> then the usability fix after. Dionna was planning on working on that
> >>> fix.
> >>>
> >>> In that flow how does userspace get the data? Its called the ioctl
> >>> with not enough output buffer space. What if the userspace calls the
> >>> ioctl with no buffers space allocated, so its trying to query the
> >>> length. We just send the host the request without any encrypted data.
> >>
> >> In the case of SNP_GUEST_REQ_INVALID_LEN, userspace wouldn't get the data
> >> if it hasn't supplied enough buffer space. But, the sev-guest driver can
> >> supply enough buffer space and invoke the SNP Extended Guest Request again
> >> in order to successfully complete the call and update the sequence
> >> numbers. The sev-guest driver would just discard the data in this case,
> >> but pass back the original "not enough buffer space" error to the caller,
> >> who could now allocate space and retry. This then allows the sequence
> >> numbers to be bumped properly.
> >>
> >
> > The way I thought to solve this was to make certificate length
> > querying a part of the specified protocol.
> >
> > The first ext_guest_request command /must/ query the certificate
> > buffer length with req.certs_len == 0.
>
> This becomes an incompatible change to the GHCB specification.
>
> > By making this part of the protocol, the sev-guest driver can check if
> > the certificate length has been requested before.
> > If so, emulate the host's VMM error code for invalid length without
> > sending an encrypted message.
>
> On the hypervisor side, the certificate blob can be replaced at any time
> with a new blob that is larger. So you may still have to handle the case
> where you get a SNP_GUEST_REQ_INVALID_LEN even if you previously asked before.
>
> > If not, then send an all zeroes request buffer with the req.certs_len
> > = 0 values to the VMM.
> >
> > The VMM will respond with the size if indeed the expected_pages are >
> > 0. In the case that the host has not set the certificate buffer yet,
> > then the host will inspect the header of the request page for a zero
> > sequence number. If so, then we know that we don't have a valid
> > request. We treat this also as the INVALID_LEN case but still return
> > the size of 0. The driver will have the expected pages value stored as
> > 0 at this point, so subsequent calls will not have this behavior.
> >
> > The way /dev/sev-guest user code has been written, I don't think this
> > will break any existing software package.

>
> I think having the sev-guest driver re-issue the request with the internal
> buffer when it receives SNP_GUEST_REQ_INVALID_LEN is the better way to go.

I take it you mean in the case that the host's certs_len == 0?

> You could still cache the size request and always return that to
> user-space when a request is received with a 0 length. The user-space
> program must be able to handle receiving multiple
> SNP_GUEST_REQ_INVALID_LEN in succession anyway, because of the fact that
> the hypervisor can be updating the certs asynchronously. And if you get a
> request that is not 0 length, then you issue it as such and re-use the
> logic of the first 0 length request that was received if you get an
> SNP_GUEST_REQ_INVALID_LEN with the user-space supplied value.
>

A request that gets SNP_GUEST_REQ_INVALID_LEN when the guest expects
that it is providing a sufficiently sized certificate buffer means
that the guest has encrypted its report request.
We then have a harder problem than throttling because not only do we
have to reissue the same request, it must be with different
certificate arguments provided from user space.

> Peter, is this something you could change the patch to do?
>
> >
> >>>
> >>>>
> >>>> For the rate-limiting patch series [1], the rate-limiting will have to be
> >>>> performed within the kernel, while the mutex is held, and then retry the
> >>>> exact request again. Otherwise, that error will require disabling the
> >>>> VMPCK. Either that, or the hypervisor must provide the rate limiting.
> >>>>
> >>>> Thoughts?
> >>>>
> >>>> [1] https://lore.kernel.org/lkml/20221013160040.2858732-1-dionnaglaze@google.com/
> >>>
> >>> Yes I think if the host rate limits the guest. The guest kernel should
> >>> retry the exact message. Which mutex are you referring too?
> >>
> >> Or the host waits and then submits the request and the guest kernel
> >> doesn't have to do anything. The mutex I'm referring to is the
> >> snp_cmd_mutex that is taken in snp_guest_ioctl().
> >
> > I think that either the host kernel or guest kernel waiting can lead
> > to unacceptable delays.
> > I would recommend that we add a zero argument ioctl to /dev/sev-guest
> > specifically for retrying the last request.
> >
> > We can know what the last request is due to the sev_cmd_mutex serialization.
> > The driver will just keep a scratch buffer for this. Any other request
> > that comes in without resolving the retry will get an -EBUSY error
> > code.
>
> And the first caller will have received an -EAGAIN in order to
> differentiate between the two situations?

Yes, the throttled caller gets -EAGAIN, and other ioctls other than
retry after that get -EBUSY.

>
> I think that sounds reasonable, but there are some catches. You will need
> to ensure that the caller that is supposed to retry does actually retry
> and that a caller that does retry is the same caller that was told to retry.
>

I think that constitutes a change to task_struct, the way that there's
a buffer for interrupted system calls.
That seems a bit much. Do we have to model for protocol-breaking user
tasks that have access to /dev/sev-guest?
The caller that gets -EAGAIN knows to retry. There's no reason for
other tasks to retry due to command serialization and the -EBUSY
behavior.


-- 
-Dionna Glaze, PhD (she/her)
