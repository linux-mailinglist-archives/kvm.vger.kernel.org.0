Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5FBB60FB28
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 17:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbiJ0PG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 11:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235681AbiJ0PG4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 11:06:56 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A365718E28D
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:06:54 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id g12so3593589lfh.3
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WIdLQNuytZkorvIt0iYzABxBmXfBbOTFDad7NjHrb8w=;
        b=rLBO2f+cYRGGwlzVDOP1TRiRWoXiawz6JfCjPvFUJOs68fxJHwzFVOQOOrl3boGVvb
         4+pSggMvw5P17ZtkUpeqZpSnYDaRT5sOObeqnrwjsiqa38EYttrhqJ+X+W8I1BJiQ7Tk
         2tTm77giAGBMC42dK4qyf79zpbBZ+6jKqWZBuXvaq26+TUu0KYYAXMUOCqVKBJoz5yPX
         BC22ddB5svwyMVHG5Ixgk9pge9higyvihlDkvxHcuG6YpED9zkBJ8AiFV9pfmG4xQB92
         nwjKzl9R1pgX9spZKIMPnXhl/3YCgcn1jMoaIryF9Qf7jUykVXD3sXHF0oQmK7n80bN3
         WEZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WIdLQNuytZkorvIt0iYzABxBmXfBbOTFDad7NjHrb8w=;
        b=cZxb3MNGrxs03e5jhgHgThxyWqOtH3UcCitP2DBpf4Pl3hVN8nuhdlYZ7D4DZ4dicg
         XAcDTMV9pi7tAg6gWjHHKexwHMGvK1MeUDsL13+c1UDlEA4FYiyI/O0YMobKEcxLHAJB
         6EGcG/WJhEyIo2DOEDoMDsd3s/pFCQuOyzuBzGFkXzWI7weqASlyKGfoca+b0JafPBXi
         XiQKNQCEd7w4jUzkA3qY8vU3cLmuBPMHaIOZ2vSWlvSIxqEhoAgUeBnoVGuVBpUo8hDv
         monOlHt4L1UtYnvbp3xuN4y8vQjETJJqFh8f2xHd1u8ku1QqquPuQ8n6ZJsb+D8ar9bq
         Ac3A==
X-Gm-Message-State: ACrzQf3iPXMEGAgSDRu/fpnX/q9aMqGKBDQg0Iy+1RedsXgOqDkBneRI
        MnuobgPEJzvpkX23wvh/hjrWcs3SDgyaYNFvFGL5Ug==
X-Google-Smtp-Source: AMsMyM6Ltbmo/H9tyNWT8cnwcnneqvwQNJUfmjQYXOVaqGBho8JkNT5DOr1Ua4/y2ACZRNtxddy4JufIjdrsTOjVAXA=
X-Received: by 2002:ac2:58c7:0:b0:4ae:394b:6a97 with SMTP id
 u7-20020ac258c7000000b004ae394b6a97mr5947567lfo.291.1666883212673; Thu, 27
 Oct 2022 08:06:52 -0700 (PDT)
MIME-Version: 1.0
References: <20221021173328.2489411-1-pgonda@google.com> <b7414cda-9924-33c3-68da-9b26b2bcc0b6@amd.com>
 <CAMkAt6rCPYi3EewVfrTb6ie5VZwSnY0aEv_oDT4pom9dLTgf9A@mail.gmail.com> <93846971-7477-6f03-a6b4-f1461254719b@amd.com>
In-Reply-To: <93846971-7477-6f03-a6b4-f1461254719b@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 27 Oct 2022 09:06:40 -0600
Message-ID: <CAMkAt6qoKNaPPkSmjX-nyRhCFPJMAOxkRxF28Szp0EpJxQK=eg@mail.gmail.com>
Subject: Re: [PATCH V2] virt: Prevent IV reuse in SNP guest driver
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Dionna Glaze <dionnaglaze@google.com>,
        Borislav Petkov <bp@suse.de>,
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 21, 2022 at 3:27 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 10/21/22 15:57, Peter Gonda wrote:
> > On Fri, Oct 21, 2022 at 1:02 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> >> On 10/21/22 12:33, Peter Gonda wrote:
> >>> The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
> >>> communicate securely with each other. The IV to this scheme is a
> >>> sequence number that both the ASP and the guest track. Currently this
> >>> sequence number in a guest request must exactly match the sequence
> >>> number tracked by the ASP. This means that if the guest sees an error
> >>> from the host during a request it can only retry that exact request or
> >>> disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
> >>> reuse see:
> >>> https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf
> >>>
> >>> To handle userspace querying the cert_data length. Instead of requesting
> >>> the cert length from userspace use the size of the drivers allocated
> >>> shared buffer. Then copy that buffer to userspace, or give userspace an
> >>> error depending on the size of the buffer given by userspace.
> >>>
> >>> Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")
> >>> Signed-off-by: Peter Gonda <pgonda@google.com>
> >>> Reported-by: Peter Gonda <pgonda@google.com>
> >>> Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
> >>> Cc: Borislav Petkov <bp@suse.de>
> >>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> >>> Cc: Michael Roth <michael.roth@amd.com>
> >>> Cc: Haowen Bai <baihaowen@meizu.com>
> >>> Cc: Yang Yingliang <yangyingliang@huawei.com>
> >>> Cc: Marc Orr <marcorr@google.com>
> >>> Cc: David Rientjes <rientjes@google.com>
> >>> Cc: Ashish Kalra <Ashish.Kalra@amd.com>
> >>> Cc: linux-kernel@vger.kernel.org
> >>> Cc: kvm@vger.kernel.org
> >>> ---
>
> >>> @@ -477,25 +496,37 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
> >>>        if (!resp)
> >>>                return -ENOMEM;
> >>>
> >>> -     snp_dev->input.data_npages = npages;
> >>> +     snp_dev->input.data_npages = sizeof(*snp_dev->certs_data) >> PAGE_SHIFT;
> >>>        ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg->msg_version,
> >>>                                   SNP_MSG_REPORT_REQ, &req.data,
> >>>                                   sizeof(req.data), resp->data, resp_len, &arg->fw_err);
> >>>
> >>> +     resp_cert_len = snp_dev->input.data_npages << PAGE_SHIFT;
> >>
> >> The hypervisor is not required to update the number of pages that the
> >> certificates actually used/required if enough pages were supplied. So this
> >> value could always remain as 4 (based on SEV_FW_BLOB_MAX_SIZE) on
> >> successful return.
> >>
> >> And if that's the case, we could always just return 4 for the number of
> >> pages no matter what. Otherwise you'll have to update the logic here if
> >> you want to obtain the actual number.
> >
> > Are you asking for this to just hard code the userspace requirement to
> > 4 pages? We could leave this as written here, that would leave the
> > guest open to a new GHCB spec where
>
> It's up to you. Ideally, if userspace provides a npages value of 0, then
> the driver issues the request with 0 and gets back the actual value. Then,
> to ensure the sequence numbers are updated, you issue the request again
> with the either the just returned value or SEV_FW_BLOB_MAX_SIZE >>
> PAGE_SHIFT. That will update the sequence numbers and the driver returns
> the number of pages required as returned from the first request.
>
> That number can also be cached and then whenever userspace calls down with
> npages of 0, immediately return the cached value. If the request ever gets
> a SNP_GUEST_REQ_INVALID_LEN with the cached value, the newly returned
> value gets cached and the driver performs the request again, like the very
> first time in order to update the sequence numbers. The driver would then
> return the new npages value back to userspace. Of course that becomes the
> "minimum" number of pages now, so even if the hypervisor reduces the size
> of the certs data, it always requires more than needed.
>
> >
> > "State from Hypervisor: on error will contain the number of guest
> > contiguous pages required to hold the data to be returned"
> >
> > Is instead:
> >
> > "State from Hypervisor: contain the number of guest contiguous pages
> > required to hold the data to be returned"
>
> If the driver always returns 4, I don't see this as requiring any change
> to the spec. It may be more than is truly needed, but that doesn't matter,
> the cert data will fit, it just may be more than necessary. This can occur
> even if you pass back the actual number, if, in between the call with 0,
> the hypervisor updates the certs such that less pages are required.
>
> >
> > I think this would be a non-breaking change since the spec says
> > nothing of the non-error case currently. Fine with your preference
> > here. Either Dionna or I can follow up with a series to allow more
> > than 4pages if needed.
>
> I'd prefer that userspace get the actual number, but really, I don't think
> it's a big deal to just return 4 until the driver can handle a more
> dynamic approach should more than 4 pages ever be needed (this would also
> require support on the hypervisor where currently not more than 4 pages
> are allowed to be provided, too).
>
> I just wanted you to be aware that in testing you're likely to see 4
> always returned to userspace.

So if you want userspace to get the actual number I think we want the
host to tell us the actual number. Currently userspace only gets a
upper bound since these requests race against host changes:

0. Host updates cert_data to be 10pages
1. Guest requests SNP EXT REQ for len query
2. Host returns 10 pages
3. Host updates cert_data to be 2pages
4. Guest requests SNP EXT REQ with 10page buffer
5. Host returns certs


I have sent a V3 series. I left this patch largely the same but added
a second patch to fix up the extended request retrying.


>
> >
> > The logic required would be parsing the GUID table? I think we'd
> > rather keep that out of the kernel driver, right?
>
> No, that's not the logic I'm thinking of. I'm just thinking of using the
> userspace specified npages and acting accordingly.
>
> Thanks,
> Tom
>
> >
