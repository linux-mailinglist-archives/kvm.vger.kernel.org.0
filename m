Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEBF587B0B
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 12:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbiHBKwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 06:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbiHBKwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 06:52:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8CE167C8;
        Tue,  2 Aug 2022 03:52:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E30FB81EA7;
        Tue,  2 Aug 2022 10:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39533C433D6;
        Tue,  2 Aug 2022 10:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659437548;
        bh=BB8N6XMAgFrpqyoNWsZ0tvWL/E8gaH0CmpJ3bsTLESA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bvp/+Xu4EENZ411axD3IpoH6BWTeWD1BzbWuRVN5T4JIsyGN98m/I6iqeOIMOvPZf
         7XMy1I4CL2DKJzOUaGy0cyQmsIWNOBVHWy2GfZxVp9zxmcSm28ZK4iqJZrb+eHzqIs
         Q11jEvvd1pv/A11p8Bxu6LbziAs+W0Y7z+o9ogDb982wS0g6MBcomzggqEGDlFTS4z
         DyqylcDdc8j9+aaU0hr6K8pmaxLcwDe2AlCZTwXmiNSeTAGRKmVaOSVRtQD0aN29AU
         lKeSmSdIEHETCu3RD4bgLGTnhBQM9LWHIA1xC/Qn5hQQ4ALKMsQ4Mo5fcRcy0uuPUL
         mRBPApIdpG0UQ==
Date:   Tue, 2 Aug 2022 13:52:25 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Peter Gonda <pgonda@google.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
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
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH Part2 v6 13/49] crypto:ccp: Provide APIs to issue SEV-SNP
 commands
Message-ID: <YukB6V7PhMeEDOZH@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <a63de5e687c530849312099ee02007089b67e92f.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6qL_p8Fp=ED5hER665GHzQn=nwZQhFg4MwHt7QanS4wVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6qL_p8Fp=ED5hER665GHzQn=nwZQhFg4MwHt7QanS4wVw@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022 at 03:43:13PM -0600, Peter Gonda wrote:
> (
> 
> On Mon, Jun 20, 2022 at 5:05 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Brijesh Singh <brijesh.singh@amd.com>
> >
> > Provide the APIs for the hypervisor to manage an SEV-SNP guest. The
> > commands for SEV-SNP is defined in the SEV-SNP firmware specification.
> >
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > ---
> >  drivers/crypto/ccp/sev-dev.c | 24 ++++++++++++
> >  include/linux/psp-sev.h      | 73 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 97 insertions(+)
> >
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> > index f1173221d0b9..35d76333e120 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > @@ -1205,6 +1205,30 @@ int sev_guest_df_flush(int *error)
> >  }
> >  EXPORT_SYMBOL_GPL(sev_guest_df_flush);
> >
> > +int snp_guest_decommission(struct sev_data_snp_decommission *data, int *error)
> > +{
> > +       return sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, data, error);
> > +}
> > +EXPORT_SYMBOL_GPL(snp_guest_decommission);
> > +
> > +int snp_guest_df_flush(int *error)
> > +{
> > +       return sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, error);
> > +}
> > +EXPORT_SYMBOL_GPL(snp_guest_df_flush);

Nit: undocumented exported functions. Both need kdoc.

> 
> Why not instead change sev_guest_df_flush() to be SNP aware? That way
> callers get the right behavior without having to know if SNP is
> enabled or not.
> 
> int sev_guest_df_flush(int *error)
> {
>   if (!psp_master || !psp_master->sev_data)
>    return -EINVAL;
> 
>   if (psp_master->sev_data->snp_inited)
>     return sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, error);
> 
>   return sev_do_cmd(SEV_CMD_DF_FLUSH, NULL, error);
> }

Because it serves no purpose to fuse them into one, and is only more
obfuscated (and also undocumented).

Two exported symbols can be traced also separately with ftrace/kprobes.

Degrading transparency is not great idea IMHO.

BR, Jarkko

