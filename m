Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C55C6E4DDC
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 17:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjDQP7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 11:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDQP7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 11:59:12 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E2BE7B
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 08:59:11 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a273b3b466so476395ad.1
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 08:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681747151; x=1684339151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JLXOmx70nsvUUD8shMVP59PfHNDNMIPrsLKqhGMmRX0=;
        b=ZNsTSPPv7L+1PbZp2QZBUSVZT1qTpsL45jnFbwg5VhiJzMNlYdcfdxeb2YkrAM8wWW
         kIjb4NWO/1NnjnmmJxdKfE3g5aB/0/7X+GRlW5NW3RBmC7Ew3qE7Z0xHVrHb4fjAN3TA
         beXpfn7G0GlqQTECpLeCl4aLWtphvd9IDffbgHZremnOVAr2yPAre6+Atms+oOW8AZgX
         TnfFm5jms9rYS/6vc26mVaY9iFdhU6YXdPMw1npvAhkmuIVDODzFP4TNQKu2Dvig3oSz
         ncOJxHvpy33Ll74o1TL7iptDJ/6wfBF70dlo/EL0boS8V3nkM+L0OqAAs3luTso50wRt
         xrgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681747151; x=1684339151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JLXOmx70nsvUUD8shMVP59PfHNDNMIPrsLKqhGMmRX0=;
        b=JUbBdZ0x5DA1xliu19qAGKF0nKe2jhHQd6t5oj6jwx6HiZJkZKH6feU9E7/H8nukvR
         dbaM7Afpq+xKE1H69NELjI7pBDMh9sa+W2+mGT6eRxLuCY55PTfYje47Sm82a16Pt0JA
         WUjUYExrvz9aUdtDrgIZVY2MDc1/+k6+A97gz6145oADdt4YiZiHCVH10+D8FBOn7Jf/
         5/WB4P2epHlR/vV3lrMoS4PGiwn6r752388o8OiR3a6ZzsfcAgcyl/jFgaujCQvS/5XE
         Qifpz51LdTP6gGNw2qVwWNa/dd9MOzSM+LqYsHMRG2JKB01Cg8vLkX7rZdVQnHq7H7+s
         lgOg==
X-Gm-Message-State: AAQBX9fFhlbqzouGyz9NAq6ejWevSTSiG49w6CJNjfT+oQtDxvCpi8c1
        KyIyncn4DmcUTcHpi+7mhLw8Ag==
X-Google-Smtp-Source: AKy350Z0NfJvH0USbljRQRzpA237A/t8j9lVPkT7Ojfni/QucJJyA2XGuJR+QCFM37WnI3dvx6YQhQ==
X-Received: by 2002:a17:902:ce0e:b0:1a6:8eda:fe4b with SMTP id k14-20020a170902ce0e00b001a68edafe4bmr490488plg.10.1681747150512;
        Mon, 17 Apr 2023 08:59:10 -0700 (PDT)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id o22-20020a17090ab89600b002467717fa60sm7242834pjr.16.2023.04.17.08.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:59:09 -0700 (PDT)
Date:   Mon, 17 Apr 2023 15:59:03 +0000
From:   Aaron Lewis <aaronlewis@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 4/8] KVM: selftests: Copy printf.c to KVM selftests
Message-ID: <ZD1sx+G2oWchaleW@google.com>
References: <20230301053425.3880773-1-aaronlewis@google.com>
 <20230301053425.3880773-5-aaronlewis@google.com>
 <ZBzM6M/Bm69KIGQQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBzM6M/Bm69KIGQQ@google.com>
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

On Thu, Mar 23, 2023, Sean Christopherson wrote:
> On Wed, Mar 01, 2023, Aaron Lewis wrote:
> > Add a local version of vsprintf() for the guest to use.
> > 
> > The file printf.c was lifted from arch/x86/boot/printf.c.
> 
> Is there by any shance a version of 
> > +/*
> > + * Oh, it's a waste of space, but oh-so-yummy for debugging.  This
> > + * version of printf() does not include 64-bit support.  "Live with
> 
> But selftests are 64-bit only, at least on x86.
> 

I think that's a legacy comment.  AFAICT this code supports 64-bit values.
I'll remove the comment to avoid confusion.

> > +static char *number(char *str, long num, int base, int size, int precision,
> > +		    int type)
> 
> Do we actually need a custom number()?  I.e. can we sub in a libc equivalent?
> That would reduce the craziness of this file by more than a few degrees.
> 

Yeah, I think we need it.  One of the biggest problems I'm trying to avoid
here is the use of LIBC in a guest.  Using it always seems to end poorly
because guests generally don't set up AVX-512 or a TLS segmet, nor should
they have to.  Calling into LIBC seems to require both of them too often,
so it seems like it's better to just avoid it.

Also, in working on v2 I upgraded vsprintf() to vsnprintf() which required
custom changes to number().
