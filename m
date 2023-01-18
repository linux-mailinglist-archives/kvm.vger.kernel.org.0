Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB94672407
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 17:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjARQtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 11:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjARQth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 11:49:37 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BD032E48
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:49:36 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id k13so4885131plg.0
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ueIUpfd1DUgokAqWbLa2RxParINZNSVYxs7BQP3qZW0=;
        b=dhI40BuSw5m8xNpwrnfEdRZyEXPvF8453ZQoJWGipjcOdzaBWb3tzSiDfjbXjOFn8S
         DKQsodRf4QrUrvlmin9oHQIA6DBIVWNucpqLJpwfuDgp+/x4cilXHb//zOOTXYGCqiQZ
         3brMpxcFxc6WwdultZ/6bUp39zSTNdsrzcsOjo88P5VBNtO7t5ViW3kiufBVUAcT5cn4
         l8hu6fdcbElM6fsHNdvSJnZ4NdFLfggB58uuuI4EMJazSe37/dGnrNByGDZjRWCV3vYn
         Lp54ajYN6zts3zOtA8/7LWQcQIIU3DAIijKAKbmuMpwh7nTyO0J7/Kl1c4ugGU0lX3KK
         AQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ueIUpfd1DUgokAqWbLa2RxParINZNSVYxs7BQP3qZW0=;
        b=IHJ9CDj6Sq0fBx8pCAmnRBV1Yt2pe8muy947inlGuxOzEW9OAO2HFt2Hy8aBnD9ilI
         hTveZvH4bexX6J0+kmiz1qxnBq0r5fKkTv7YEUtgk921VSKt/cwrxz40CMTvdwgsZ4o+
         XPUnZ/Q3+INEf24t+Ip+o7RCkMX9R8obbzkmpwcbM69UjINjcrRnV1RySx0f7teW61HZ
         mxjgs4iWxovZ2+RY5WtUP7xtpX6T+lGDN2nZF1eL2c/spImqluMPSgbm2oNRdcuwouPx
         BwIF1V2uYi6qkSBRZkKiWG3mpeHklsqGIJl48zpIJus3V3cK5HxYrlLl1NQfNZchjfNl
         rG6g==
X-Gm-Message-State: AFqh2kpnlkf5iruFfqNQ+sw+N3TLn1gr4SGv37oeMrEDtAK6lxogcTHy
        WnypNbApTWz1zEk2cCQLCI33TQ==
X-Google-Smtp-Source: AMrXdXtMU7xclx9vLCurSYOBj/ICOFPoeZ2VPbuV1kcFXdd2pyeBNXsfEA+0zwbUsQiiQTToHsI7kg==
X-Received: by 2002:a17:90a:d148:b0:229:1e87:365f with SMTP id t8-20020a17090ad14800b002291e87365fmr1934210pjw.2.1674060575827;
        Wed, 18 Jan 2023 08:49:35 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i22-20020a63e456000000b004a4dc6aeae3sm19330830pgk.74.2023.01.18.08.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 08:49:35 -0800 (PST)
Date:   Wed, 18 Jan 2023 16:49:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, bgardon@google.com, oupton@google.com,
        ricarkol@google.com
Subject: Re: [PATCH 1/3] KVM: selftests: Allocate additional space for
 latency samples
Message-ID: <Y8gjG6gG5UR6T3Yg@google.com>
References: <20221115173258.2530923-1-coltonlewis@google.com>
 <20221115173258.2530923-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115173258.2530923-2-coltonlewis@google.com>
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

On Tue, Nov 15, 2022, Colton Lewis wrote:
> Allocate additional space for latency samples. This has been separated
> out to call attention to the additional VM memory allocation.

A blurb in the changelog is sufficient, no need to split allocation and use into two
patches.  I would actually collapse all three into one.  The changes aren't so big
that errors will be difficult to bisect, and without the final printing, the other
changes are useless for all intents and purposes, i.e. if for some reason we want
to revert the sampling, it will be all or nothing.

I do think it makes sense to separate the system counter stuff to a separate
patch (and land it in generic code), e.g. add helpers to read the system counter
from the guest and convert the result to nanoseconds in a separate patch.
