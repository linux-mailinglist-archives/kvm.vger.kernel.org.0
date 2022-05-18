Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116C252C646
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 00:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiERWaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 18:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiERWaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 18:30:20 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6784721A961
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 15:30:19 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2f863469afbso40319377b3.0
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 15:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+m9W8seUbvXKl6nr+C4wVmU3fKzJvSA46/4AFIxjC/g=;
        b=oFY8lh88qWhUOzYIBD52Kxc5Hp9y99aSHxVmukR1bQJlMjeSiN6SogZ7KZFbPWSYeE
         Wy5jBPwDCNorEsYR+kqPfu/DS9a/8xtA+EzpEGXUZNe9J5DgIRnosJ7AJRWiFPuneEGn
         e1S+/iemZP111JJUQWlY7QGahlueLVXAqKVtU7iPVjX160f0hbEJwucuFdzMMuWZ/Rlh
         4sREXo8vxkl6aTmga2pZPJcxfr4MNI232OuvlAaLRCxxplDoXdlv2mlBfFKKizxyR1wy
         CMGv3py6k+XbWVQ5B6bYoQIgKLLd6nEoxguoICnGcFio4OgP9zVMePafWLNT1DIK8i6y
         sMhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+m9W8seUbvXKl6nr+C4wVmU3fKzJvSA46/4AFIxjC/g=;
        b=TpgdfgVN8urNXArUpene6SVdSTdHE5YhNr5jypMZcscL1C+K1YeeT+4W8IhShtePoe
         d7gJnq+id1gvZhCAcTbC6mE3P6obKIB/AoTpWVKJZy1VyifRZRdw5tG6YaVmfOKCrJu7
         BzDihCwW6S0+qS86kEZELCWbMjjcKzbnG8wOtLCI7AFVjTN1wWWe4ZkL6STBzfihiC6e
         IxAeXTSXtuQH0Xqfi6GCVvXM3nFE4y1JoVyJLGte8/OTG7ntOWvifvTQjrSKdkp16ASX
         0GIGGt/D9SKprPmFFq3YONfOVa61p8AAWlNdtkuvDNloQeG0tr5vYrJ9jWd4mCJJnOT/
         UZPg==
X-Gm-Message-State: AOAM5311yicGVM+u5ES0GhCFmiW6rqZaBdd3L3Wuqq4igdlnEpDy4S8r
        wpoQY8jhZBXt7+W04w/HsiQPOEgLDiwp9l3wwbaixA==
X-Google-Smtp-Source: ABdhPJzAYY67X9FbC/TchBr8eDrXDx6+SdQaCLrsk5Q/7HSnALn3by5bmRA75gIzUxEpt9e4EzC6LZKhFX61FLl4DX0=
X-Received: by 2002:a81:6188:0:b0:2eb:4bd3:9b86 with SMTP id
 v130-20020a816188000000b002eb4bd39b86mr1664631ywb.46.1652913018341; Wed, 18
 May 2022 15:30:18 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649219184.git.kai.huang@intel.com> <145620795852bf24ba2124a3f8234fd4aaac19d4.1649219184.git.kai.huang@intel.com>
 <f929fb7a-5bdc-2567-77aa-762a098c8513@intel.com> <0bab7221179229317a11311386c968bd0d40e344.camel@intel.com>
In-Reply-To: <0bab7221179229317a11311386c968bd0d40e344.camel@intel.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Wed, 18 May 2022 15:30:07 -0700
Message-ID: <CAAhR5DGNGJ=MAMPOsbZ2jEOEXG_vR69L77ks4ihMUhixPTuXLA@mail.gmail.com>
Subject: Re: [PATCH v3 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Apr 27, 2022 at 5:15 PM Kai Huang <kai.huang@intel.com> wrote:
>
> On Wed, 2022-04-27 at 15:15 -0700, Dave Hansen wrote:
> > On 4/5/22 21:49, Kai Huang wrote:
> > > TDX provides increased levels of memory confidentiality and integrity.
> > > This requires special hardware support for features like memory
> > > encryption and storage of memory integrity checksums.  Not all memory
> > > satisfies these requirements.
> > >
> > > As a result, TDX introduced the concept of a "Convertible Memory Region"
> > > (CMR).  During boot, the firmware builds a list of all of the memory
> > > ranges which can provide the TDX security guarantees.  The list of these
> > > ranges, along with TDX module information, is available to the kernel by
> > > querying the TDX module via TDH.SYS.INFO SEAMCALL.
> > >
> > > Host kernel can choose whether or not to use all convertible memory
> > > regions as TDX memory.  Before TDX module is ready to create any TD
> > > guests, all TDX memory regions that host kernel intends to use must be
> > > configured to the TDX module, using specific data structures defined by
> > > TDX architecture.  Constructing those structures requires information of
> > > both TDX module and the Convertible Memory Regions.  Call TDH.SYS.INFO
> > > to get this information as preparation to construct those structures.
> > >
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > >  arch/x86/virt/vmx/tdx/tdx.c | 131 ++++++++++++++++++++++++++++++++++++
> > >  arch/x86/virt/vmx/tdx/tdx.h |  61 +++++++++++++++++
> > >  2 files changed, 192 insertions(+)
> > >
> > > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > > index ef2718423f0f..482e6d858181 100644
> > > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > > @@ -80,6 +80,11 @@ static DEFINE_MUTEX(tdx_module_lock);
> > >
> > >  static struct p_seamldr_info p_seamldr_info;
> > >
> > > +/* Base address of CMR array needs to be 512 bytes aligned. */
> > > +static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
> > > +static int tdx_cmr_num;
> > > +static struct tdsysinfo_struct tdx_sysinfo;
> >
> > I really dislike mixing hardware and software structures.  Please make
> > it clear which of these are fully software-defined and which are part of
> > the hardware ABI.
>
> Both 'struct tdsysinfo_struct' and 'struct cmr_info' are hardware structures.
> They are defined in tdx.h which has a comment saying the data structures below
> this comment is hardware structures:
>
>         +/*
>         + * TDX architectural data structures
>         + */
>
> It is introduced in the P-SEAMLDR patch.
>
> Should I explicitly add comments around the variables saying they are used by
> hardware, something like:
>
>         /*
>          * Data structures used by TDH.SYS.INFO SEAMCALL to return CMRs and
>          * TDX module system information.
>          */
>
> ?
>
> >
> > >  static bool __seamrr_enabled(void)
> > >  {
> > >     return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
> > > @@ -468,6 +473,127 @@ static int tdx_module_init_cpus(void)
> > >     return seamcall_on_each_cpu(&sc);
> > >  }
> > >
> > > +static inline bool cmr_valid(struct cmr_info *cmr)
> > > +{
> > > +   return !!cmr->size;
> > > +}
> > > +
> > > +static void print_cmrs(struct cmr_info *cmr_array, int cmr_num,
> > > +                  const char *name)
> > > +{
> > > +   int i;
> > > +
> > > +   for (i = 0; i < cmr_num; i++) {
> > > +           struct cmr_info *cmr = &cmr_array[i];
> > > +
> > > +           pr_info("%s : [0x%llx, 0x%llx)\n", name,
> > > +                           cmr->base, cmr->base + cmr->size);
> > > +   }
> > > +}
> > > +
> > > +static int sanitize_cmrs(struct cmr_info *cmr_array, int cmr_num)
> > > +{
> > > +   int i, j;
> > > +
> > > +   /*
> > > +    * Intel TDX module spec, 20.7.3 CMR_INFO:
> > > +    *
> > > +    *   TDH.SYS.INFO leaf function returns a MAX_CMRS (32) entry
> > > +    *   array of CMR_INFO entries. The CMRs are sorted from the
> > > +    *   lowest base address to the highest base address, and they
> > > +    *   are non-overlapping.
> > > +    *
> > > +    * This implies that BIOS may generate invalid empty entries
> > > +    * if total CMRs are less than 32.  Skip them manually.
> > > +    */
> > > +   for (i = 0; i < cmr_num; i++) {
> > > +           struct cmr_info *cmr = &cmr_array[i];
> > > +           struct cmr_info *prev_cmr = NULL;
> > > +
> > > +           /* Skip further invalid CMRs */
> > > +           if (!cmr_valid(cmr))
> > > +                   break;
> > > +
> > > +           if (i > 0)
> > > +                   prev_cmr = &cmr_array[i - 1];
> > > +
> > > +           /*
> > > +            * It is a TDX firmware bug if CMRs are not
> > > +            * in address ascending order.
> > > +            */
> > > +           if (prev_cmr && ((prev_cmr->base + prev_cmr->size) >
> > > +                                   cmr->base)) {
> > > +                   pr_err("Firmware bug: CMRs not in address ascending order.\n");
> > > +                   return -EFAULT;
> >
> > -EFAULT is a really weird return code to use for this.  I'd use -EINVAL.
>
> OK thanks.
>
> >
> > > +           }
> > > +   }
> > > +
> > > +   /*
> > > +    * Also a sane BIOS should never generate invalid CMR(s) between
> > > +    * two valid CMRs.  Sanity check this and simply return error in
> > > +    * this case.
> > > +    *
> > > +    * By reaching here @i is the index of the first invalid CMR (or
> > > +    * cmr_num).  Starting with next entry of @i since it has already
> > > +    * been checked.
> > > +    */
> > > +   for (j = i + 1; j < cmr_num; j++)
> > > +           if (cmr_valid(&cmr_array[j])) {
> > > +                   pr_err("Firmware bug: invalid CMR(s) among valid CMRs.\n");
> > > +                   return -EFAULT;
> > > +           }
> >
> > Please add brackets for the for().
>
> OK.
>
> >
> > > +   /*
> > > +    * Trim all tail invalid empty CMRs.  BIOS should generate at
> > > +    * least one valid CMR, otherwise it's a TDX firmware bug.
> > > +    */
> > > +   tdx_cmr_num = i;
> > > +   if (!tdx_cmr_num) {
> > > +           pr_err("Firmware bug: No valid CMR.\n");
> > > +           return -EFAULT;
> > > +   }
> > > +
> > > +   /* Print kernel sanitized CMRs */
> > > +   print_cmrs(tdx_cmr_array, tdx_cmr_num, "Kernel-sanitized-CMR");
> > > +
> > > +   return 0;
> > > +}
> > > +
> > > +static int tdx_get_sysinfo(void)
> > > +{
> > > +   struct tdx_module_output out;
> > > +   u64 tdsysinfo_sz, cmr_num;
> > > +   int ret;
> > > +
> > > +   BUILD_BUG_ON(sizeof(struct tdsysinfo_struct) != TDSYSINFO_STRUCT_SIZE);
> > > +
> > > +   ret = seamcall(TDH_SYS_INFO, __pa(&tdx_sysinfo), TDSYSINFO_STRUCT_SIZE,
> > > +                   __pa(tdx_cmr_array), MAX_CMRS, NULL, &out);
> > > +   if (ret)
> > > +           return ret;
> > > +
> > > +   /*
> > > +    * If TDH.SYS.CONFIG succeeds, RDX contains the actual bytes
> > > +    * written to @tdx_sysinfo and R9 contains the actual entries
> > > +    * written to @tdx_cmr_array.  Sanity check them.
> > > +    */
> > > +   tdsysinfo_sz = out.rdx;
> > > +   cmr_num = out.r9;
> >
> > Please vertically align things like this:
> >
> >       tdsysinfo_sz = out.rdx;
> >       cmr_num      = out.r9;
>
> OK.
>
> >
> > > +   if (WARN_ON_ONCE((tdsysinfo_sz > sizeof(tdx_sysinfo)) || !tdsysinfo_sz ||
> > > +                           (cmr_num > MAX_CMRS) || !cmr_num))
> > > +           return -EFAULT;
> >
> > Sanity checking is good, but this makes me wonder how much is too much.
> >  I don't see a lot of code for instance checking if sys_write() writes
> > more than how much it was supposed to.
> >
> > Why are these sanity checks necessary here?  Is the TDX module expected
> > to be *THAT* buggy?  The thing that's providing, oh, basically all of
> > the security guarantees of this architecture.  It's overflowing the
> > buffers you hand it?
>
> I think this check can be removed.  Will remove.
>
> >
> > > +   pr_info("TDX module: vendor_id 0x%x, major_version %u, minor_version %u, build_date %u, build_num %u",
> > > +           tdx_sysinfo.vendor_id, tdx_sysinfo.major_version,
> > > +           tdx_sysinfo.minor_version, tdx_sysinfo.build_date,
> > > +           tdx_sysinfo.build_num);
> > > +
> > > +   /* Print BIOS provided CMRs */
> > > +   print_cmrs(tdx_cmr_array, cmr_num, "BIOS-CMR");
> > > +

sanitize_cmrs already prints the cmrs in case of success. So for valid
cmrs we are going to print them twice.
Would it be better to only print cmrs here in case sanitize_cmrs fails?

> > > +   return sanitize_cmrs(tdx_cmr_array, cmr_num);
> > > +}
> >
> > Does sanitize_cmrs() sanitize anything?  It looks to me like it *checks*
> > the CMRs.  But, sanitizing is an active operation that writes to the
> > data being sanitized.  This looks read-only to me.  check_cmrs() would
> > be a better name for a passive check.
>
> Sure will change to check_cmrs().
>
> >
> > >  static int init_tdx_module(void)
> > >  {
> > >     int ret;
> > > @@ -482,6 +608,11 @@ static int init_tdx_module(void)
> > >     if (ret)
> > >             goto out;
> > >
> > > +   /* Get TDX module information and CMRs */
> > > +   ret = tdx_get_sysinfo();
> > > +   if (ret)
> > > +           goto out;
> >
> > Couldn't we get rid of that comment if you did something like:
> >
> >       ret = tdx_get_sysinfo(&tdx_cmr_array, &tdx_sysinfo);
>
> Yes will do.
>
> >
> > and preferably make the variables function-local.
>
> 'tdx_sysinfo' will be used by KVM too.
>
>
>
> --
> Thanks,
> -Kai
>
>

Sagi
