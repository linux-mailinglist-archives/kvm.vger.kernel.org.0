Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1271F5624B6
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 23:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237103AbiF3VAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 17:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbiF3VAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 17:00:40 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0AD4D158
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 14:00:39 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s206so492832pgs.3
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 14:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=glTDnYjItqLfny8iWt7QuauUYNw+sI+czBNtwZqbRGg=;
        b=CrYN13mmUcZnBcrFJl7hETioGstd6NnSORG00INxT1zUYbocQz5nf2cBCHpPEOC7B+
         NQHIVOBDSaoO5rdJPdbg0miDk1FDFYTNIqpcgqLiuZLYUFTpLhm4jM1VIGyi68ooyljB
         6P1dA6cLN2vuV6BfC6HTK9eY6bnNLiFVrCxmQXyxlk9cr7TSIHCUOOyz/xRI0Od1okDI
         3IGCj0ItlvK4icAcKUS8Ze0pPgTJegxcc6A2DjL848asAF+1VqQ3KnEluZ6eUstJX6MC
         r59Jz8ocGhHU/n6lzYnqcA0cpOBsO8fE6wO2Nsgei43TAraOau8JeEqzBM/KVVZSV2VJ
         vVEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=glTDnYjItqLfny8iWt7QuauUYNw+sI+czBNtwZqbRGg=;
        b=l/A1MkGob5ZU7kXJHbcRAoezIRSxuufCk7IqYh7vxGxYxhADWp5wkk2TqHT9iyNMiO
         j8briYtgiYG7jiWMQzZNZf8zdTCTzS6PtHn1JDJEdT+x277ybeBy/I0WKXXF1YfPcYZ8
         34ZIKE1WfVxP/3rvHdO+Z5V84PP529gkKmRdkEpd4W4r6h9A+AUYy7ytra2NaKu/Z7o2
         4+WNnw3XDi457X4sD5VXJHF+V0DTaHswPV6xnp1QvtnbIQa1If15m3f1DYBP9g3+9jyW
         lYaShIRwEsEm6c7EUZWI4u3/FrT62J2WWFCoYwmmwpBCMZL+hbvwMI0sfB53rIdH2Dw8
         jg7Q==
X-Gm-Message-State: AJIora8ubYh/60r6W82JgowKUVEVNGRGiQo/CSsuih+TTs/4nLUhZnZy
        TzIVQTLmTFxhFTyNsoAPXMSjtP+GBh58cEUShYfw/w==
X-Google-Smtp-Source: AGRyM1uRjBRHlyoqB+nuPe0+Or9vp6fLCk+VrWwqfN5R1SDm7JnYk8I/e9lKO/JYbEqCng+siojBRDrtWuS/LqpPYOc=
X-Received: by 2002:a63:1943:0:b0:411:5e12:4e4f with SMTP id
 3-20020a631943000000b004115e124e4fmr9154187pgz.400.1656622838523; Thu, 30 Jun
 2022 14:00:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220330174621.1567317-1-bgardon@google.com> <20220330174621.1567317-3-bgardon@google.com>
 <YlCSWH4pob00vZq3@google.com>
In-Reply-To: <YlCSWH4pob00vZq3@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Thu, 30 Jun 2022 14:00:27 -0700
Message-ID: <CAL715W+9U=5rp3+j3wG46t0Uvq-UAOFduC-AXz-Z9ZJVQXDzDg@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] KVM: selftests: Dump VM stats in binary stats test
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 8, 2022 at 12:52 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Mar 30, 2022, Ben Gardon wrote:
> > Add kvm_util library functions to read KVM stats through the binary
> > stats interface and then dump them to stdout when running the binary
> > stats test. Subsequent commits will extend the kvm_util code and use it
> > to make assertions in a test for NX hugepages.
>
> Why?  Spamming my console with info that has zero meaning to me and is useless
> when the test passes is not helpful.  Even on failure, I don't see what the user
> is going to do with this information, all of the asserts are completly unrelated
> to the stats themselves.

Debugging could be another reason, I suspect? I remember when I tried
to use the interface, there is really no API that tells me "did I add
this stat successfully and/or correctly?" I think having a general
print so that developer/debugging folk could just 'grep mystat' to
verify that would be helpful in the future.

Otherwise, they have to write code themselves to do the dirty print...
