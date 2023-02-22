Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B64869FB79
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 19:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbjBVSvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 13:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjBVSvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 13:51:41 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4474C2B
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 10:51:39 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536bf635080so84693097b3.23
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 10:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yqEECA7T14uUEIASP+IpGDgg85ZCOvdRmhNcjI3Iles=;
        b=qFu2nZFTrTIDgiui6Mnc8nAfWXy3MGuClnECitY08YuGQQb9v6QJj0VhQlA1Hne1PX
         jwbFjOAh23hL3XupWMXZLLCXKP4THYXpwTr42U1/q1g/QQfC4G2UWmMJyoEBLapf31zr
         9fMEjCBZJjzx/JmpivZXbiOKlQHgUAMx6sN9r3/FCL+Jj7XJGZLGZQ97FlgwMMVBEVNM
         9fIitAEtjpeHnK+4ww/FLrj3EscM62WsIQie3jEK2g6DQO1Xip7pL3Yng35IBOv/bAxe
         x4u6XdkQANWQh3E7/i3BPLdBdEkQDUHrPuK+JE1eZA6241r6sMUD9BLBydK2LBAn6kE5
         6Qpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yqEECA7T14uUEIASP+IpGDgg85ZCOvdRmhNcjI3Iles=;
        b=ho3ZkQnTTNwksYKZpjHZkmqJmx0bzdSz+XpigwXHOhQ52H3sUeaXk9whIbEWsj+18d
         JaWmGE15k15HIgmQlB3IZdn7noYlV7Noqo42NvgvyTDTn+uhgyWef32E4AIeIbLuph5r
         squXO+M0RvUfX8BEGL3vhm3QWbL4akEvYO8Cf9yyUlKNWdN3TYwNpiV8xVCIz1VqwqZT
         q9bD/LL95st+KlGJg6KVsMHWUc6HWNduMdxsEzwiD2nc8/wtR5IHQesjKhIMKgfnhMsa
         aviHC8thr/xlKGdKnTQpnI6ok6tW1e/mLzNcMOl0wNDa2YYkX6lIVWSosgKm4GZqeS3j
         pRTA==
X-Gm-Message-State: AO0yUKVnTP1SkyvmnQoGdxlacWYoqttPzpMdTXxnHH9zbOeZm4pyKxpk
        CmjoywP4iCEwAbhtSViNO60T6PHG+RU=
X-Google-Smtp-Source: AK7set+8IP+LPPuvRfdebQR1ad4tDs9Va9qipjTvwoCKkZH0ygi5W3DkzGpQdJCQHMTdaByTbpW1nzgLFfc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1:b0:a27:40c4:e12c with SMTP id
 l1-20020a056902000100b00a2740c4e12cmr54899ybh.2.1677091898129; Wed, 22 Feb
 2023 10:51:38 -0800 (PST)
Date:   Wed, 22 Feb 2023 10:51:36 -0800
In-Reply-To: <20230220034910.11024-1-shahuang@redhat.com>
Mime-Version: 1.0
References: <20230220034910.11024-1-shahuang@redhat.com>
Message-ID: <Y/ZkOFL0O5szHsYP@google.com>
Subject: Re: [PATCH] KVM: Add the missed title format
From:   Sean Christopherson <seanjc@google.com>
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 20, 2023, Shaoqin Huang wrote:
> The 7.18 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 now is not a title, make it
> as a title to keep the format consistent.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>

Looks like it simply got missed by the ReST conversion.

Fixes: 106ee47dc633 ("docs: kvm: Convert api.txt to ReST format")
Reviewed-by: Sean Christopherson <seanjc@google.com>
