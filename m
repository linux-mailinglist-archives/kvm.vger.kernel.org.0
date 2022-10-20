Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD056606378
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 16:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiJTOrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 10:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiJTOrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 10:47:04 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38D5A8792
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 07:47:02 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id r14so33996104lfm.2
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 07:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p+QLcntPNquWGA1ARPKGqcsFovLnDGGACStBc6YWpJE=;
        b=WGaWzXNmStE18xevdTnFF7SFzon6bb6zpTKu05Cvb/sWRr/Yl798OoETjUYO0PRSYp
         xRaZFTO78m3ojbvMzB3MOPK02Q8D/5tdJ3wrtzc/6Pc/TuW6k/QG5Utr1RkkNePw8a9y
         EXUT1qHq/rVQK+Cl99tY0X3OhaIsKSyBATMqS1cacvvIpyss1fdkHjtbqmggiDzmKqBT
         LTaIbA77mDafWDX39O3WcdQnQrWGT2DrVvZi2MOaVhu/WqHRMX3snvdWmrTjZ0yGf4gF
         MiPpMDC+dCVKj3+lDH3YOFy3lSYNehZEXMfmgiK1hjRjvfeIqeYZZBR5NadIh35vUVrZ
         D5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p+QLcntPNquWGA1ARPKGqcsFovLnDGGACStBc6YWpJE=;
        b=hbaloPToXV5Cb8pCzkOUOT1Q06aljzXm4x8SMXxqlo1sEluWo0nVNsRowbpMQYhm2S
         2xPZtU3hK6/YDreyfI2tzn0sMWGGdMwUyYxG3bIHqCfQ69qkrsGk7BrsSbaL6jyMZMsl
         0fkLvf7V+E4Wo4gsFziPO1EC5jHJaPGgQeNHJEoBm4J7hUc/qTIzXAQ8jEN+N29FDG1l
         jEVE+1jUuT3Ff545UQWIiaEXQFSMvrQjTp4Gyvq5XQRav2ObdPFVKsTtSC4pafHGFiIj
         vKfp6ohcQpfHN1HVnZMo1tf2BmOUbQTOI+xR2MhfykrCF9NnYmrX/nSyGKGrfZRvELH3
         mOXA==
X-Gm-Message-State: ACrzQf3KbdXfifHlrNsaM8eQfAmK2Gsx+oVbClNosL31zn05bxkls1Cl
        AwZdRDaNmlkgbTfKTAzoz7U5gGPRPEfhxROV1Y0NXg==
X-Google-Smtp-Source: AMsMyM6kt+/AcdRolhlWvfCUWwkN1TI+8ZVTwkmYAf3ufmRK1hu/bT4Q1AWe2MNyQhIWzOKq/NcU+haMFp+R7RpkDDc=
X-Received: by 2002:a05:6512:521:b0:4a2:7576:82f4 with SMTP id
 o1-20020a056512052100b004a2757682f4mr5236360lfc.558.1666277220192; Thu, 20
 Oct 2022 07:47:00 -0700 (PDT)
MIME-Version: 1.0
References: <20221019150333.1047423-1-pgonda@google.com> <528937ab-8046-d5d1-26ff-50ef35f5635f@amd.com>
 <CAMkAt6ritG1zmOreh9WYLYAGww0EJQy+m-Y0nfxD5+gpTkpJ1w@mail.gmail.com>
 <821e750b-26c9-3331-7577-5cb832a35afa@amd.com> <CAAH4kHYhLkiN7H03GKgMU+3h9rhp2a03gNFGLbrNtjp=PYYHQw@mail.gmail.com>
 <5621c2b6-a5eb-c786-afee-020e97c0e4c8@amd.com> <CAMkAt6pCPmf++Dg=x5bSN4-gR-s7BuYiryOGvGezLupFN9aEKw@mail.gmail.com>
 <948704a4-2348-041f-4f46-bbf42d985549@amd.com> <CAMkAt6rb-f3qCb7Np-SdHd7u87-zShFpYkWcA910uYXUafqtPQ@mail.gmail.com>
 <195a9a2d-d758-e70f-335f-c394b0c587ad@amd.com>
In-Reply-To: <195a9a2d-d758-e70f-335f-c394b0c587ad@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 20 Oct 2022 08:46:48 -0600
Message-ID: <CAMkAt6qFDS3GgCPZD-T6Ro4VSrTwy7oww9NnAw5Vyu_9SBRpZg@mail.gmail.com>
Subject: Re: [PATCH] virt: Prevent AES-GCM IV reuse in SNP guest driver
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Dionna Amalie Glaze <dionnaglaze@google.com>,
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
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022 at 8:02 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 10/19/22 16:47, Peter Gonda wrote:
> > On Wed, Oct 19, 2022 at 2:58 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> >> On 10/19/22 15:39, Peter Gonda wrote:
> >>> On Wed, Oct 19, 2022 at 1:56 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> >>>> On 10/19/22 14:17, Dionna Amalie Glaze wrote:
> >>>>> On Wed, Oct 19, 2022 at 11:44 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> >>>>>> On 10/19/22 12:40, Peter Gonda wrote:
> >>>>>>> On Wed, Oct 19, 2022 at 11:03 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> >>>>>>>> On 10/19/22 10:03, Peter Gonda wrote:
> >>>>>>>>> The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
> >>>>>>>>> communicate securely with each other. The IV to this scheme is a
> >>>>>>>>> sequence number that both the ASP and the guest track. Currently this
> >>>>>>>>> sequence number in a guest request must exactly match the sequence
> >>>>>>>>> number tracked by the ASP. This means that if the guest sees an error
> >>>>>>>>> from the host during a request it can only retry that exact request or
> >>>>>>>>> disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
> >>>>>>>>> reuse see:
> >>>>>>>>> https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf
>
> >>> OK so the guest retires with the same request when it gets an
> >>> SNP_GUEST_REQ_INVALID_LEN error. It expands its internal buffer to
> >>
> >> It would just use the pre-allocated snp_dev->certs_data buffer with npages
> >> set to the full size of that buffer.
> >
> > Actually we allocate that buffer with size SEV_FW_BLOB_MAX_SIZE. Maybe
> > we want to just allocate this buffer which we think is sufficient and
> > never increase the allocation?
> >
> > I see the size of
> > https://developer.amd.com/wp-content/resources/ask_ark_milan.cert is
> > 3200 bytes. Assuming the VCEK cert is the same size (which it should
> > be since this .cert is 2 certificates). 16K seems to leave enough room
> > even for some vendor certificates?
>
> I think just using the 16K buffer (4 pages) as it is allocated today is
> ok. If we get a SNP_GUEST_REQ_INVALID_LEN error that is larger than 4
> pages, then we won't ever be able to pull the certs given how the driver
> is coded today. In that case, disabling the VMPCK is in order.
>
> A separate patch could be submitted later to improve this overall aspect
> of the certs buffer if needed.

If that sounds OK I'd prefer that. This keeps the drivers current limit:

static int get_ext_report(struct snp_guest_dev *snp_dev, struct
snp_guest_request_ioctl *arg)
...
if (req.certs_len > SEV_FW_BLOB_MAX_SIZE ||
    !IS_ALIGNED(req.certs_len, PAGE_SIZE))
return -EINVAL;

I'd prefer not to add extra features during the bug fix. But happy to
make this work with buffers greater than SEV_FW_BLOB_MAX_SIZE as
follow up if you want.

>
> Thanks,
> Tom
>
> >
> >>
> >>> hold the certificates. When it finally gets a successful request w/
> >>> certs. Do we want to return the attestation bits to userspace, but
> >>> leave out the certificate data. Or just error out the ioctl
> >>> completely?
> >>
> >> We need to be able to return the attestation bits that came back with the
> >> extra certs. So just error out of the ioctl with the length error and let
> >> user-space retry with the recommended number of pages.
> >
> > That sounded simpler to me. Will do.
> >
> >>
> >>>
> >>> I can do that in this series.
> >>
> >> Thanks!
> >>
> >>>
> >>>>
> >>>>>
> >>>>>>>
> >>>>>>>>
> >>>>>>>> For the rate-limiting patch series [1], the rate-limiting will have to be
> >>>>>>>> performed within the kernel, while the mutex is held, and then retry the
> >>>>>>>> exact request again. Otherwise, that error will require disabling the
> >>>>>>>> VMPCK. Either that, or the hypervisor must provide the rate limiting.
> >>>>>>>>
> >>>>>>>> Thoughts?
> >>>>>>>>
> >>>>>>>> [1] https://lore.kernel.org/lkml/20221013160040.2858732-1-dionnaglaze@google.com/
> >>>>>>>
> >>>>>>> Yes I think if the host rate limits the guest. The guest kernel should
> >>>>>>> retry the exact message. Which mutex are you referring too?
> >>>>>>
> >>>>>> Or the host waits and then submits the request and the guest kernel
> >>>>>> doesn't have to do anything. The mutex I'm referring to is the
> >>>>>> snp_cmd_mutex that is taken in snp_guest_ioctl().
> >>>>>
> >>>>> I think that either the host kernel or guest kernel waiting can lead
> >>>>> to unacceptable delays.
> >>>>> I would recommend that we add a zero argument ioctl to /dev/sev-guest
> >>>>> specifically for retrying the last request.
> >>>>>
> >>>>> We can know what the last request is due to the sev_cmd_mutex serialization.
> >>>>> The driver will just keep a scratch buffer for this. Any other request
> >>>>> that comes in without resolving the retry will get an -EBUSY error
> >>>>> code.
> >>>>
> >>>> And the first caller will have received an -EAGAIN in order to
> >>>> differentiate between the two situations?
> >>>>
> >>>>>
> >>>>> Calling the retry ioctl without a pending command will result in -EINVAL.
> >>>>>
> >>>>> Let me know what you think.
> >>>>
> >>>> I think that sounds reasonable, but there are some catches. You will need
> >>>> to ensure that the caller that is supposed to retry does actually retry
> >>>> and that a caller that does retry is the same caller that was told to retry.
> >>>
> >>> Whats the issue with the guest driver taking some time?
> >>>
> >>> This sounds complex because there may be many users of the driver. How
> >>> do multiple users coordinate when they need to use the retry ioctl?
> >>>
> >>>>
> >>>> Thanks,
> >>>> Tom
> >>>>
> >>>>>>
> >>>>>> Thanks,
> >>>>>> Tom
> >>>>>
> >>>>>
> >>>>>
