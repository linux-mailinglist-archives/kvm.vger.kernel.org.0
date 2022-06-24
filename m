Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE3A559B5E
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 16:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbiFXOUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 10:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiFXOUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 10:20:07 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA70353A6B
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 07:20:05 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id b21so2259838ljf.1
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 07:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DX4gKze+gSLugENwiJT/N67T0nY4kiuroWR4tE5f6EI=;
        b=VfEBDmF+RRx2AePp1LKNOXvU7WJWT/O2vbwOK6TcFPNB4pQVsyY0RfX4vhJAh+Mbnb
         CSpLC4DuU04b6TaGJLqjByKLSlK8rMKagv+1X/BnF+DG6FGTeJTqco41IJxg4BBknO2c
         9nU6xj5VrURoXdlBlHE2MMDs0tD3YctaUDGt7Tex6JVeCdE7WaXXjW/s4w+mK5j07sok
         iU8nUCW2GGMNSUiRP8CU+ZLEXk2iKTAe2x+UOMTYWOweClggqSOEWwk7/xetU7NHaeBl
         PymrdlAltUTGV2UX8jh43nTF58/YGtacCmmHQYeAbukWxoteTQOVOrjG4tdcO81x/oRY
         ogCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DX4gKze+gSLugENwiJT/N67T0nY4kiuroWR4tE5f6EI=;
        b=4LbhuMay9fCHFkBT+z3LCh0T5o28/Z6KMVf1t17ha10eoXqNHnfPBZMvMbUwjGkldQ
         a9tdD0VMHTya/iIdYf5tZNhYdoEpeUze8k1S4dNTrdwUP2u4xbrmqbnTjiLsJByaU783
         LIJYS5nJm3CWQRMXhf5bg1HhGUfy2CvsI4rWDfrEYC1wR9Qf/S7TOaFvMCMZR6+Cksbf
         g1zNiUJ7mBewlk2AfyRV+fYz5d4aatMBkbFB2W1omAQiR7G9NJq/RovRTA2iySBYFKXt
         7QKcBxEWVUEEdW+TRWNVqZVMA9dGjxZeiHZb/vxN58MyTMcuTdLTKmZj2Opz6QA6d4UP
         Oaaw==
X-Gm-Message-State: AJIora9Y2px2NieNe5tJ3H2A4ZT6al7LEJmvTHqIFX8eS6b8H7G5YYAN
        Y2gZrUwn6BzzADI3hS/dcGRL3icCSSQGhAAzP2cS3w==
X-Google-Smtp-Source: AGRyM1vckgLN+sbO6XgC0Dq/BPpCpn8v6O+aur4z8QeasCmZg9NVntlD3MncTmewgOzkhrloR2oEBJ1vuZjhWgVXoSA=
X-Received: by 2002:a2e:2a43:0:b0:25a:84a9:921c with SMTP id
 q64-20020a2e2a43000000b0025a84a9921cmr7482170ljq.83.1656080403810; Fri, 24
 Jun 2022 07:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6ruxMazN3NmWHsemDNQj6Uj0PhCVeaxw2unCxU=YZFRWw@mail.gmail.com> <SN6PR12MB276722570164ECD120BA4D628EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB276722570164ECD120BA4D628EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 24 Jun 2022 08:19:52 -0600
Message-ID: <CAMkAt6pcsgp7BK4WGnvTTNayN9zD8wx5CjprnY2Xe_RnpP3sEA@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022 at 2:17 PM Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
>
> [Public]
>
> Hello Peter,
>
> >> +static int snp_reclaim_pages(unsigned long pfn, unsigned int npages,
> >> +bool locked) {
> >> +       struct sev_data_snp_page_reclaim data;
> >> +       int ret, err, i, n =3D 0;
> >> +
> >> +       for (i =3D 0; i < npages; i++) {
>
> >What about setting |n| here too, also the other increments.
>
> >for (i =3D 0, n =3D 0; i < npages; i++, n++, pfn++)
>
> Yes that is simpler.
>
> >> +               memset(&data, 0, sizeof(data));
> >> +               data.paddr =3D pfn << PAGE_SHIFT;
> >> +
> >> +               if (locked)
> >> +                       ret =3D __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_R=
ECLAIM, &data, &err);
> >> +               else
> >> +                       ret =3D sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM,
> >> + &data, &err);
>
> > Can we change `sev_cmd_mutex` to some sort of nesting lock type? That c=
ould clean up this if (locked) code.
>
> > +static inline int rmp_make_firmware(unsigned long pfn, int level) {
> > +       return rmp_make_private(pfn, 0, level, 0, true); }
> > +
> > +static int snp_set_rmp_state(unsigned long paddr, unsigned int npages,=
 bool to_fw, bool locked,
> > +                            bool need_reclaim)
>
> >This function can do a lot and when I read the call sites its hard to se=
e what its doing since we have a combination of arguments which tell us wha=
t behavior is happening, some of which are not valid (ex: to_fw =3D=3D true=
 and need_reclaim =3D=3D true is an >invalid argument combination).
>
> to_fw is used to make a firmware page and need_reclaim is for freeing the=
 firmware page, so they are going to be mutually exclusive.
>
> I actually can connect with it quite logically with the callers :
> snp_alloc_firmware_pages will call with to_fw =3D true and need_reclaim =
=3D false
> and snp_free_firmware_pages will do the opposite, to_fw =3D false and nee=
d_reclaim =3D true.
>
> That seems straightforward to look at.

This might be a preference thing but I find it not straightforward.
When I am reading through unmap_firmware_writeable() and I see

  /* Transition the pre-allocated buffer to the firmware state. */
  if (snp_set_rmp_state(__pa(map->host), npages, true, true, false))
   return -EFAULT;

I don't actually know what snp_set_rmp_state() is doing unless I go
look at the definition and see what all those booleans mean. This is
unlike the rmp_make_shared() and rmp_make_private() functions, each of
which tells me a lot more about what the function will do just from
the name.


>
> >Also this for loop over |npages| is duplicated from snp_reclaim_pages().=
 One improvement here is that on the current
> >snp_reclaim_pages() if we fail to reclaim a page we assume we cannot rec=
laim the next pages, this may cause us to snp_leak_pages() more pages than =
we actually need too.
>
> Yes that is true.
>
> >What about something like this?
>
> >static snp_leak_page(u64 pfn, enum pg_level level) {
> >   memory_failure(pfn, 0);
> >   dump_rmpentry(pfn);
> >}
>
> >static int snp_reclaim_page(u64 pfn, enum pg_level level) {
> >  int ret;
> >  struct sev_data_snp_page_reclaim data;
>
> >  ret =3D sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> >  if (ret)
> >    goto cleanup;
>
> >  ret =3D rmp_make_shared(pfn, level);
> >  if (ret)
> >    goto cleanup;
>
> > return 0;
>
> >cleanup:
> >    snp_leak_page(pfn, level)
> >}
>
> >typedef int (*rmp_state_change_func) (u64 pfn, enum pg_level level);
>
> >static int snp_set_rmp_state(unsigned long paddr, unsigned int npages, r=
mp_state_change_func state_change, rmp_state_change_func cleanup) {
> >  struct sev_data_snp_page_reclaim data;
> >  int ret, err, i, n =3D 0;
>
> >  for (i =3D 0, n =3D 0; i < npages; i++, n++, pfn++) {
> >    ret =3D state_change(pfn, PG_LEVEL_4K)
> >    if (ret)
> >      goto cleanup;
> >  }
>
> >  return 0;
>
> > cleanup:
> >  for (; i>=3D 0; i--, n--, pfn--) {
> >    cleanup(pfn, PG_LEVEL_4K);
> >  }
>
> >  return ret;
> >}
>
> >Then inside of __snp_alloc_firmware_pages():
>
> >snp_set_rmp_state(paddr, npages, rmp_make_firmware, snp_reclaim_page);
>
> >And inside of __snp_free_firmware_pages():
>
> >snp_set_rmp_state(paddr, npages, snp_reclaim_page, snp_leak_page);
>
> >Just a suggestion feel free to ignore. The readability comment could be =
addressed much less invasively by just making separate functions for each v=
alid combination of arguments here. Like snp_set_rmp_fw_state(), snp_set_rm=
p_shared_state(),
> >snp_set_rmp_release_state() or something.
>
> >> +static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int
> >> +order, bool locked) {
> >> +       unsigned long npages =3D 1ul << order, paddr;
> >> +       struct sev_device *sev;
> >> +       struct page *page;
> >> +
> >> +       if (!psp_master || !psp_master->sev_data)
> >> +               return NULL;
> >> +
> >> +       page =3D alloc_pages(gfp_mask, order);
> >> +       if (!page)
> >> +               return NULL;
> >> +
> >> +       /* If SEV-SNP is initialized then add the page in RMP table. *=
/
> >> +       sev =3D psp_master->sev_data;
> >> +       if (!sev->snp_inited)
> >> +               return page;
> >> +
> >> +       paddr =3D __pa((unsigned long)page_address(page));
> >> +       if (snp_set_rmp_state(paddr, npages, true, locked, false))
> >> +               return NULL;
>
> >So what about the case where snp_set_rmp_state() fails but we were able =
to reclaim all the pages? Should we be able to signal that to callers so th=
at we could free |page| here? But given this is an error path already maybe=
 we can optimize this in a >follow up series.
>
> Yes, we should actually tie in to snp_reclaim_pages() success or failure =
here in the case we were able to successfully unroll some or all of the fir=
mware state change.
>
> > +
> > +       return page;
> > +}
> > +
> > +void *snp_alloc_firmware_page(gfp_t gfp_mask) {
> > +       struct page *page;
> > +
> > +       page =3D __snp_alloc_firmware_pages(gfp_mask, 0, false);
> > +
> > +       return page ? page_address(page) : NULL; }
> > +EXPORT_SYMBOL_GPL(snp_alloc_firmware_page);
> > +
> > +static void __snp_free_firmware_pages(struct page *page, int order,
> > +bool locked) {
> > +       unsigned long paddr, npages =3D 1ul << order;
> > +
> > +       if (!page)
> > +               return;
> > +
> > +       paddr =3D __pa((unsigned long)page_address(page));
> > +       if (snp_set_rmp_state(paddr, npages, false, locked, true))
> > +               return;
>
> > Here we may be able to free some of |page| depending how where inside o=
f snp_set_rmp_state() we failed. But again given this is an error path alre=
ady maybe we can optimize this in a follow up series.
>
> Yes, we probably should be able to free some of the page(s) depending on =
how many page(s) got reclaimed in snp_set_rmp_state().
> But these reclamation failures may not be very common, so any failure is =
indicative of a bigger issue, it might be the case when there is a single p=
age reclamation error it might happen with all the subsequent
> pages and so follow a simple recovery procedure, then handling a more com=
plex recovery for a chunk of pages being reclaimed and another chunk not.
>
> Thanks,
> Ashish
>
>
>
