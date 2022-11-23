Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE49636A01
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 20:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238466AbiKWToY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 14:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233560AbiKWToW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 14:44:22 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE1993CC7
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 11:44:20 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id x17so17536147wrn.6
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 11:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Hrl6+3qmvAqDeMuij9blfcXYnf1KVu5G00Q9l3GMlnI=;
        b=SNovYVTaZmO0i+VnP2+4GFFrm8M+cqdooCqNRT7svES0he9+w5RVtLotpNrcU7982X
         LrLz6V60QxdPoJHrUcQq5Yi/016rZZw+hFIDQ5N78JYzo6sUd59t7JCOfz1yqRFq8K+x
         XzuPHmZG+Vys29d4fZgydGrf9sGytKRWFckJO1JhzSL2NN1aFyD2s52suWj7EQAHmAas
         bGiMLZnScoritgF3Tca3OVmNqoZNGFfExjRnblQeGzblWkyHgqrrai3hzq34LsLxSuDp
         krz1xGxUwxCK4A+OUfInMuu55uUEW/9uDqdF9nCody/6Y+zwVMMlEPlPA04I5dkSY2j9
         S+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hrl6+3qmvAqDeMuij9blfcXYnf1KVu5G00Q9l3GMlnI=;
        b=FWdJn8+DqunqkZ0QLC+7FTVGaaVvNxjofmudQU/bssZQJHw7S7R+fUda2pT3y5a2VX
         SV0D3dm2BC6MZ/un1eHg/HySP7by7OWsltDJnT5yn60s/z6fB3fSXqN5AlWc+Kqny828
         UrppRLoW001OXjIo9Qq42DT2F1k2U9T/SQxSBbWrkrqy3xC1RdMgHyoPo5ZSrPcE66zw
         j9IG7fY3jFFZynuG+7NLXmjc+CjewU7JeokOQWcL/f8WZh0ASjVu5ir+FUD3vvzqh36T
         Fvz5tOAfanO2eGEAWZzRXLrtW5RXj7u8naonWea5q1XLAlqXmmeW29tkQOUASpczwMzO
         QrlA==
X-Gm-Message-State: ANoB5pkDJDvqhntINVaXeI/177Oe+oJJjrK38S3XrXsEDUXHKqFNPOo6
        QRikjfCnripaA8taqqMkcsFg0xlsAaVd7GalUcD5Xw==
X-Google-Smtp-Source: AA0mqf6bb0QGlHd6yp3zuA753A/Y1GCQ8KoTIzjf+fG+DQ5GjEgC7BqGOxHfiGNv0ZasiH0RSpsggZdUCpi/YmhPtuM=
X-Received: by 2002:a05:6000:1192:b0:241:e7a6:9135 with SMTP id
 g18-20020a056000119200b00241e7a69135mr4550464wrx.641.1669232659216; Wed, 23
 Nov 2022 11:44:19 -0800 (PST)
MIME-Version: 1.0
References: <20221121234026.3037083-1-vipinsh@google.com> <20221121234026.3037083-3-vipinsh@google.com>
 <87bkozosvh.fsf@ovpn-194-185.brq.redhat.com>
In-Reply-To: <87bkozosvh.fsf@ovpn-194-185.brq.redhat.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 23 Nov 2022 11:43:43 -0800
Message-ID: <CAHVum0eW4WMHe1vNsWn-2xbMxgckFwu_pOQR7hs0NbFj3sM8Tg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] KVM: x86: hyper-v: Add extended hypercall support
 in Hyper-v
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
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

On Tue, Nov 22, 2022 at 8:29 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Vipin Sharma <vipinsh@google.com> writes:
>
> > +/*
> > + * The TLFS carves out 64 possible extended hypercalls, numbered sequentially
> > + * after the base capabilities extended hypercall.
> > + */
> > +#define HV_EXT_CALL_MAX (HV_EXT_CALL_QUERY_CAPABILITIES + 64)
> > +
>
> First, I thought there's an off-by-one here (and should be '63') but
> then I checked with TLFS and figured out that the limit comes from
> HvExtCallQueryCapabilities's response which doesn't include itself
> (0x8001) in the mask, this means it can encode
>
> 0x8002 == bit0
> 0x8003 == bit1
> ..
> 0x8041 == bit63
>
> so indeed, the last one supported is 0x8041 == 0x8001 + 64
>
> maybe it's worth extending the commont on where '64' comes from.
>

Yeah, I will expand comments.

> >  static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
> >                               bool vcpu_kick);
> >
> > @@ -2411,6 +2417,9 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
> >       case HVCALL_SEND_IPI:
> >               return hv_vcpu->cpuid_cache.enlightenments_eax &
> >                       HV_X64_CLUSTER_IPI_RECOMMENDED;
> > +     case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
> > +             return hv_vcpu->cpuid_cache.features_ebx &
> > +                             HV_ENABLE_EXTENDED_HYPERCALLS;
> >       default:
> >               break;
> >       }
> > @@ -2564,6 +2573,12 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> >               }
> >               goto hypercall_userspace_exit;
> >       }
> > +     case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
> > +             if (unlikely(hc.fast)) {
> > +                     ret = HV_STATUS_INVALID_PARAMETER;
>
> I wasn't able to find any statement in TLFS stating whether extended
> hypercalls can be 'fast', I can imagine e.g. MemoryHeatHintAsync using
> it. Unfortunatelly, our userspace exit will have to be modified to
> handle such stuff. This can stay for the time being I guess..
>

I agree TLFS doesn't state anything about "fast" extended hypercall
but nothing stops in future for some call to be "fast". I think this
condition should also be handled by userspace as it is handling
everything else.

I will remove it in the next version of the patch. I don't see any
value in verification here.

> > +                     break;
> > +             }
> > +             goto hypercall_userspace_exit;
> >       default:
> >               ret = HV_STATUS_INVALID_HYPERCALL_CODE;
> >               break;
> > @@ -2722,6 +2737,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
> >
> >                       ent->ebx |= HV_POST_MESSAGES;
> >                       ent->ebx |= HV_SIGNAL_EVENTS;
> > +                     ent->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
> >
> >                       ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
> >                       ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> --
> Vitaly
>
