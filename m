Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6C44EA16A
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 22:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344461AbiC1UYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 16:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344202AbiC1UYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 16:24:09 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D9E6661F;
        Mon, 28 Mar 2022 13:22:28 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id j13so15670653plj.8;
        Mon, 28 Mar 2022 13:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B1JAmnTCv9N5y9VvzOqUAURfGVMjEH3u/bC26DkhB7w=;
        b=m48Uy/1NjaSl+kpUOY+IH2xbvKSDjkYm9j73xJRnmkPk7cCSW7c1FLr75qmYt0EmKq
         ZFr2NWXWZrWc4RtRz0uPSfC53aw5FqjJQA1IuH+1AG7YNSOG3xM81TYrav9kq4miRLTm
         sdSYNLic3Dka9e5wkf3Dxgb0W245Doshi/OzAJgmmJoxbgnqM0atwgAiYObvVI+Y/WkD
         pawPIkTU3walePF11svyaz1LEPONcBPFeMlGlkzZps4LV6atosCAi3Y6FDBNpPSlPoYn
         60ipxsoIRB3PcjIuYI2dtByzS1mzdeZM4vCfhOoXKW8yX0nFLseVs/nj20vUz06BTpoV
         3cMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B1JAmnTCv9N5y9VvzOqUAURfGVMjEH3u/bC26DkhB7w=;
        b=hvQiPQoA/kscHDf6RbtfhKR5V6vdw5a1ucGz8TKzGZx9pIfxP4zCYO0pMZNdpXP9pf
         V+sZXbDvRjjGMnDQc46s3yIMkTRp25IJLDSGn66a8rwjLO6mucivFaf/bP47cXSM/8ZK
         YhRP7/tAtZEDsxs6J+G89AGB76MnUYOpF4tZlQP4kBN0ZnD5G7P3QnjUFhMAGXTYXsuH
         JyC3QTRaOIsfj1N+8qdxBLdErXh+93j0riSD5XD9k0Tdfm8olP/e4NgBZgheC55E1F/c
         CWfpsRlt4a/ZRyHQV89jHv2B9ZjUoVMznt1fsg/eJ4q8aYRfRmQdbIzfbF/TOjWGeCtH
         yTCA==
X-Gm-Message-State: AOAM530mxqSXI1xIAS7E9/33LGf9P4vwaSZXfhpjr7BImcicr8ueG17Z
        F/S+Sne+eH//1iF2VxTzuPI=
X-Google-Smtp-Source: ABdhPJz2zLaDxPtKESrpE3jkUxJ9lJTWxfRfkAkw6Y550Pzs35AIre+dIjsX5cyRIIpbe0SxkkXOmw==
X-Received: by 2002:a17:902:d652:b0:153:ad02:741c with SMTP id y18-20020a170902d65200b00153ad02741cmr27144106plh.135.1648498947862;
        Mon, 28 Mar 2022 13:22:27 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id w6-20020a17090a460600b001bf355e964fsm336842pjg.0.2022.03.28.13.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 13:22:27 -0700 (PDT)
Date:   Mon, 28 Mar 2022 13:22:25 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com
Subject: Re: [PATCH v2 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
Message-ID: <20220328202225.GA1525925@ls.amr.corp.intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
 <98c1010509aa412e7f05b12187cacf40451d5246.1647167475.git.kai.huang@intel.com>
 <20220324174301.GA1212881@ls.amr.corp.intel.com>
 <f211441a6d23321e22517684159e2c28c8492b86.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f211441a6d23321e22517684159e2c28c8492b86.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022 at 02:30:05PM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> 
> > > +
> > > +static int sanitize_cmrs(struct cmr_info *cmr_array, int cmr_num)
> > > +{
> > > +	int i, j;
> > > +
> > > +	/*
> > > +	 * Intel TDX module spec, 20.7.3 CMR_INFO:
> > > +	 *
> > > +	 *   TDH.SYS.INFO leaf function returns a MAX_CMRS (32) entry
> > > +	 *   array of CMR_INFO entries. The CMRs are sorted from the
> > > +	 *   lowest base address to the highest base address, and they
> > > +	 *   are non-overlapping.
> > > +	 *
> > > +	 * This implies that BIOS may generate invalid empty entries
> > > +	 * if total CMRs are less than 32.  Skip them manually.
> > > +	 */
> > > +	for (i = 0; i < cmr_num; i++) {
> > > +		struct cmr_info *cmr = &cmr_array[i];
> > > +		struct cmr_info *prev_cmr = NULL;
> > > +
> > > +		/* Skip further invalid CMRs */
> > > +		if (!cmr_valid(cmr))
> > > +			break;
> > > +
> > > +		if (i > 0)
> > > +			prev_cmr = &cmr_array[i - 1];
> > > +
> > > +		/*
> > > +		 * It is a TDX firmware bug if CMRs are not
> > > +		 * in address ascending order.
> > > +		 */
> > > +		if (prev_cmr && ((prev_cmr->base + prev_cmr->size) >
> > > +					cmr->base)) {
> > > +			pr_err("Firmware bug: CMRs not in address ascending order.\n");
> > > +			return -EFAULT;
> > > +		}
> > > +	}
> > > +
> > > +	/*
> > > +	 * Also a sane BIOS should never generate invalid CMR(s) between
> > > +	 * two valid CMRs.  Sanity check this and simply return error in
> > > +	 * this case.
> > > +	 */
> > > +	for (j = i; j < cmr_num; j++)
> > > +		if (cmr_valid(&cmr_array[j])) {
> > > +			pr_err("Firmware bug: invalid CMR(s) among valid CMRs.\n");
> > > +			return -EFAULT;
> > > +		}
> > 
> > This check doesn't make sense because above i-for loop has break.
> 
> The break in above i-for loop will hit at the first invalid CMR entry.  Yes "j =
> i" will make double check on this invalid CMR entry, but it should have no
> problem.  Or we can change to "j = i + 1" to skip the first invalid CMR entry.
> 
> Does this make sense?

It makes sense. Somehow I missed j = i. I scratch my review.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
