Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFCD65F676
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 23:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbjAEWJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 17:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235726AbjAEWJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 17:09:01 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFFB6953B
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 14:08:59 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id r130so33184622oih.2
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 14:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bn7Z6oDABvJGYJVlfHzj/OFR2MilP9KE/xPylqtRaI8=;
        b=LPsmEqdAF17ASsCpSdQFeo9d4yZM+w20RGOPe9inlsD+sZCird0lne6ib9WTiUsoq6
         2YgzaklAwt7/d/G7TwXebs7qINP7lo6g4gokBAoTDbEuLNRCPOur2bdGaSB5436CIeQq
         ow56Fuel0bIs5L34wyTU1If5GO/VcfHRlBWxOg8w8qsR3+7n9GR21BPqtWii9RShhyO4
         sK4o0wllJQDfn0fBTBRKdj+90uTkehVGEmVCx2XkcMotlGcWsc49QFRAovOssriMnEgU
         2rvFg916i1tZO2H3RWKP5p1gJ4gYmWV4zvrIbxxpj3BvvCGMhW7SujCWmA146HEcnYhg
         iNbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bn7Z6oDABvJGYJVlfHzj/OFR2MilP9KE/xPylqtRaI8=;
        b=Vo3oibld/A6GQiPvaRRBl0b+OY6sA5WFvJwuAmnMjFlpu/Xat9hdyF0noiTdvIzTJD
         uSXSSsep7NKvbCZJrpCE3n37UCR7KG0t+S2WCCFGuyCAKxRr6kh/apoL6gmxY7QMabAD
         HAFf9KyIA1HvO0Tenc1AL1kl+ncWbSsoAN6TXJPGqwi6I3goi2jLVBYZuuu6NG3jlP+3
         pPIgNAhbEsQ3L3hSXWxpS+6eiC9Qg22gBk13WuZzZXcIRJ5SbFmOcqvVjV4KrtPBn000
         9RBsS8k5YGDdTRlLCKt8OBXiGrfP7d4fPufyiVU9lrcV7Q9i1iXFiZkURDfFNCkRxJ3K
         64qg==
X-Gm-Message-State: AFqh2kpJIJ/pGs+6lnnPumISvamjfSLulRWHfn4IqByb1R4V0TyAumz9
        XIGUMDoayttbHUxJpmmJwU6/2rwH1EpO1uILw2fMAg==
X-Google-Smtp-Source: AMrXdXuxkMBtlIcBn4GdWW98m54t/OKdTbEuF+GncEMuoeBfYSSzt5Own7F/lydDPhj0/ruVF7sknqqThK7mIt4x8Js=
X-Received: by 2002:a05:6808:3947:b0:354:7fd4:f17b with SMTP id
 en7-20020a056808394700b003547fd4f17bmr2403497oib.221.1672956538794; Thu, 05
 Jan 2023 14:08:58 -0800 (PST)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
 <YuFvbm/Zck9Tr5pq@zn.tnic> <20221219150026.bltiyk72pmdc2ic3@amd.com>
 <Y6DEv4QuvIfwWlCW@zn.tnic> <ab96e918-c8b7-67d5-1dfd-320264858cec@amd.com>
In-Reply-To: <ab96e918-c8b7-67d5-1dfd-320264858cec@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 5 Jan 2023 14:08:47 -0800
Message-ID: <CAA03e5GKCcevo7goyyRqWrgk3KeFPTddb-E2pRmgDmyPSNxDvA@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 07/49] x86/sev: Invalid pages from direct map
 when adding it to RMP table
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org
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

On Tue, Dec 27, 2022 at 1:49 PM Kalra, Ashish <ashish.kalra@amd.com> wrote:
>
> Hello Boris,
>
> On 12/19/2022 2:08 PM, Borislav Petkov wrote:
> > On Mon, Dec 19, 2022 at 09:00:26AM -0600, Michael Roth wrote:
> >> We implemented this approach for v7, but it causes a fairly significant
> >> performance regression, particularly for the case for npages > 1 which
> >> this change was meant to optimize.
> >>
> >> I still need to dig in a big but I'm guessing it's related to flushing
> >> behavior.
> >
> > Well, AFAICT, change_page_attr_set_clr() flushes once at the end.
> >
> > Don't you need to flush when you modify the direct map?
> >
>
> Milan onward, there is H/W support for coherency between mappings of the
> same physical page with different encryption keys, so AFAIK, there
> should be no need to flush during page state transitions, where we
> invoke these direct map interface functions for re-mapping/invalidating
> pages.
>
> I don't know if there is any other reason to flush after modifying
> the direct map ?

Isn't the Milan coherence feature (SME_COHERENT?) about the caches --
not the TLBs? And isn't the flushing being discussed here about the
TLBs?

Also, I thought that Mingwei Zhang <mizhang@google.com> found that the
Milan SEV coherence feature was basically unusable in Linux because it
only works across CPUs. It does not extend to IO (e.g., CPU caches
need to be flushed prior to free'ing a SEV VM's private address and
reallocating that location to a device driver to be used for IO). My
understanding of this feature and its limitations may be too coarse.
But I think we should be very careful about relying on this feature as
it is implemented in Milan.

That being said, I guess I could see an argument to rely on the
feature here, since we're not deallocating the memory and reallocating
it to a device. But again, I thought the feature was about cache
coherence -- not TLB coherence.
