Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647A16C52A1
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 18:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjCVRhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 13:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjCVRhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 13:37:37 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8EC64AB1
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 10:37:24 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id z11so11585948pfh.4
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 10:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679506644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mxkuqRl/yb2T6GWS8Wq1Cnpb9WKuo9byFw6bPkoxxJg=;
        b=dkEtYVS0qeye+8Xs/2B4QFy36XUZuVGmlq4hQjusWVCLJxtWjiDTNUFliYcu19cI+0
         5AlM3Noz9VBwnZlf7vwUV8pbMTMJSVZVUEbpojJY/6xTnUBPrwHNuIt89EaxYx1EX5vA
         RbNleqOa72FrzX0r+wRjPkE1kqyniO/esSpytB9bmzW4nB4NHs0+6RPpAxo5W9prK/2h
         cN6tD2AlFZWqCIqltm3Rmn0Otbd1sxeHJggS8twXYsJHb1riZIDo2jm6X5KzLffB7wnq
         iF8jM3LdgDXghR93zp30XlCshDnFHBYDdInupBh5nyJ6Vd6e4xVCpdd1zNIDHjopN7nj
         d9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679506644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mxkuqRl/yb2T6GWS8Wq1Cnpb9WKuo9byFw6bPkoxxJg=;
        b=4ZUQKpFjUluUE7YUbUwMRn0bm+nKjoISJ8qifoMZyVsbEVldfjXzA6L00+f1qvKYlv
         6rZSqOTTOUNprhZmHcwyXzvbpnwzqx8DlpYrDlAQmS8wX2r18QpjEphrXLV1tzSmKFdA
         e3PBZwqKBDUiXwjQVfj25GTEBfld1KvelpLz5mhCqnZN8+7YftSFxk3SGAa8OibovMPi
         FjSN57L0XZKQwHLBGwstpVBn8usH8cFvMK7eum05zy2duH+mfWQZNxvmJtFEjo6WR2ie
         UBdFbk9R4nfAfDbYGqLaqJX0RyrWKfjCJjO4zUtHfU+V5je3Lra4FgLy0wkB5A8sPBY1
         8lNg==
X-Gm-Message-State: AO0yUKXfw3DF5ayFHu7g1e6huLqwMATE/Mtrrs5pcjtzmLl/FSpTa8Pt
        HnTNMYWeipRF1f78v4KtWhZcLPSONqoD5WyobFRDCQ==
X-Google-Smtp-Source: AK7set+XcaZPhkLLqvZc4ur3Bq35Ooy73YP6UnvJ3RONmIW+luTAhqB9kxdSi/24R1YteS0yYkxd+sl3lzJgD3EyRbc=
X-Received: by 2002:aa7:88c9:0:b0:623:20a0:bf51 with SMTP id
 k9-20020aa788c9000000b0062320a0bf51mr2341747pff.2.1679506643613; Wed, 22 Mar
 2023 10:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <ZBl4592947wC7WKI@suse.de> <ZBnH600JIw1saZZ7@work-vm>
 <ZBnMZsWMJMkxOelX@suse.de> <ZBnhtEsMhuvwfY75@work-vm> <ZBn/ZbFwT9emf5zw@suse.de>
 <ZBoLVktt77F9paNV@work-vm> <ZBrIFnlPeCsP0x2g@suse.de> <444b0d8d-3a8c-8e6d-1df3-35f57046e58e@amazon.com>
 <ZBrZmbfWXVQLND/E@work-vm>
In-Reply-To: <ZBrZmbfWXVQLND/E@work-vm>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Wed, 22 Mar 2023 10:37:11 -0700
Message-ID: <CAAH4kHbYc+Wx5W_S8XFch+z1B19U_Zm=hFQr1fj1rv1S8QOvxg@mail.gmail.com>
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <jroedel@suse.de>,
        amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 22, 2023 at 3:34=E2=80=AFAM Dr. David Alan Gilbert
<dgilbert@redhat.com> wrote:
>
> * Alexander Graf (graf@amazon.com) wrote:
> > Hi J=C3=B6rg,
> >
> > On 22.03.23 10:19, J=C3=B6rg R=C3=B6del wrote:
> >
> > > On Tue, Mar 21, 2023 at 07:53:58PM +0000, Dr. David Alan Gilbert wrot=
e:
> > > > OK; the other thing that needs to get nailed down for the vTPM's is=
 the
> > > > relationship between the vTPM attestation and the SEV attestation.
> > > > i.e. how to prove that the vTPM you're dealing with is from an SNP =
host.
> > > > (Azure have a hack of putting an SNP attestation report into the vT=
PM
> > > > NVRAM; see
> > > > https://github.com/Azure/confidential-computing-cvm-guest-attestati=
on/blob/main/cvm-guest-attestation.md
> > > > )
> > > When using the SVSM TPM protocol it should be proven already that the
> > > vTPM is part of the SNP trusted base, no? The TPM communication is
> > > implicitly encrypted by the VMs memory key and the SEV attestation
> > > report proves that the correct vTPM is executing.
> >
> >
> > What you want to achieve eventually is to take a report from the vTPM a=
nd
> > submit only that to an external authorization entity that looks at it a=
nd
> > says "Yup, you ran in SEV-SNP, I trust your TCB, I trust your TPM
> > implementation, I also trust your PCR values" and based on that provide=
s
> > access to whatever resource you want to access.
> >
> > To do that, you need to link SEV-SNP and TPM measurements/reports toget=
her.
> > And the easiest way to do that is by providing the SEV-SNP report as pa=
rt of
> > the TPM: You can then use the hash of the SEV-SNP report as signing key=
 for
> > example.
>
> Yeh; I think the SVSM TPM protocol has some proof of that as well; the
> SVSM spec lists 'SVSM_ATTEST_SINGLE_SERVICE Manifest Data' that contains
> 'TPMT_PUBLIC structure of the endorsement key'.
> So I *think* that's saying that the SEV attestation report contains
> something from the EK of the vTPM.
>
> > I think the key here is that you need to propagate that link to an exte=
rnal
> > party, not (only) to the VM.
>
> Yeh.
>

Excuse my perhaps naivete, but would it not be in the TCG's wheelhouse
to specify how a TPM's firmware (SVSM) / bootloader (SEV-SNP) should
be attested? The EK as well?

I think this might need to jump back to the vTPM protocol thread since
this is about COCONUT, but I'm worried we're talking about
AMD-specific long-term formats when perhaps the trusted computing
group should be widening its scope to how a TPM should be virtualized.
I appreciate that we're attempting to solve the problem in the short
term, and certainly the SVSM will need attestation capabilities, but
the linking to the TPM is dicey without that conversation with TCG,
IMHO.

> Dave
> >
> >
> > Alex
> >
> >
> >
> >
> >
> > Amazon Development Center Germany GmbH
> > Krausenstr. 38
> > 10117 Berlin
> > Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> > Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> > Sitz: Berlin
> > Ust-ID: DE 289 237 879
> >
> >
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>
>


--=20
-Dionna Glaze, PhD (she/her)
