Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758F44B2B02
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 17:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351793AbiBKQwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 11:52:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237337AbiBKQwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 11:52:45 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF4C8D;
        Fri, 11 Feb 2022 08:52:43 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id u20so19858698ejx.3;
        Fri, 11 Feb 2022 08:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y4J/n+96ksnx895qiPFgBhQkGHxGH5BwJo5HaJpHU78=;
        b=OCNBYi7q/xXDuwkrYXNdTcqfcZidkgzB1YhFYsxZ3GH8QdoqUinJGZkYE/xh08VscO
         9OzIV3pgOQySjYL7DIxqIxwM97G6x5lUn8yON2NXcjpHQcLT6Q7Ot3fpp1j9JGbkigQ0
         JQ2md77ql9OixOus/16acgfyQDEBvNE7uz7MyttOKoHK869WfbL9a74a/AE8P6qXIyOS
         l1xKr+H5Fh+nsgGKV92T5PWqRn/zCx9bxDJlilmoeMCz5EHHmNz0XWc/shJSxkmlLcIf
         sEkToZ7tuptJ4xCqdmeRyW9h0yOXn8gHxtgS5eY8pgwUV3dCj0JMujxhLwQaLqZvZrJo
         vhJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y4J/n+96ksnx895qiPFgBhQkGHxGH5BwJo5HaJpHU78=;
        b=7MeG6vJMW9Nw3Nn1w1sCJufWrgKBOukApb0EMundcaVoHpSpHK0l6fkgHy7StAz+7M
         DRofvDjYmd0IptiiCg66lf7eBRAezvlM4vp/N2UVXJt6aXg0FtUhnHN6QdBjEI+o/37j
         D7PXO65oHoyDY+VYwkHFy3rnMT3uYOjPpuUUZKB1F5HCFNCI6QhxwIgTNUb2YRuHS8fi
         oxgYTvK4a6AjUu4ZU0yRgVA/D5scvg/6+Dt0V2l5TzszHXOt+PnCwWc0DqOMxy5Gbfvh
         +L0AovgVWmU2izIyy32tnqIkUF0nT4ZcLIXe2eP4njSrXdHVWI3/aXQn1YmO8xsZS+sX
         Dg/g==
X-Gm-Message-State: AOAM5312+q+a2Y7XYZCtOBgkoJJKBb5gqn5LjBqSW51la9rvieMmUk6u
        Wqx7INxgoI/+uF3R3kMXTBA=
X-Google-Smtp-Source: ABdhPJzb0/on9AFZt0CrwvuCleMb47XrwH/E0zRGC9xrP+u7ouMizlnOQYIAHplU0JS1NXheGqedGw==
X-Received: by 2002:a17:906:bc4c:: with SMTP id s12mr2115465ejv.675.1644598362140;
        Fri, 11 Feb 2022 08:52:42 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id i23sm4204216edr.74.2022.02.11.08.52.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 08:52:41 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <ad47de2b-84b6-aaca-2a01-ae4fd8248cad@redhat.com>
Date:   Fri, 11 Feb 2022 17:52:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 06/12] KVM: MMU: rename kvm_mmu_reload
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-7-pbonzini@redhat.com> <YgWtdUotsoBOOtXz@google.com>
 <4e05cfc5-55bb-1273-5309-46ed4fe52fed@redhat.com>
 <YgaLwvo2Gl565H3/@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgaLwvo2Gl565H3/@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 17:16, Sean Christopherson wrote:
> The other nuance that I want to avoid is the implication that KVM is checking for
> a valid root because it doesn't trust what has happened before, i.e. that the call
> is there as a safeguard.  That's misleading for the most common path, vcpu_enter_guest(),
> because when the helper does do some work, it's usually because KVM deliberately
> invalidated the root.

Fair enough.

>> I also thought of "establish_valid_root", but it has the opposite
>> problem---it does not convey well, if at all, that the root could be valid
>> already.
> 
> Heh, I agree that "establish" would imply the root is always invalid, but amusingly
> "establish" is listed as a synonym for "ensure" on the few sites of checked. Yay English.

Well, synonyms rarely have a perfectly matching meaning.

> Can we put this on the backburner for now?

Yes, of course.

Paolo

> IMO, KVM_REQ_MMU_RELOAD is far more
> misleading than kvm_mmu_reload(), and I posted a series to remedy that (though I
> need to check if it's still viable since you vetoed adding the check for a pending
> request in the page fault handler).
> 
> https://lore.kernel.org/all/20211209060552.2956723-1-seanjc@google.com

