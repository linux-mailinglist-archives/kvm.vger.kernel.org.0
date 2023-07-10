Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3806774E0EC
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 00:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjGJWS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 18:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjGJWSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 18:18:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D004819A
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 15:18:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c8f360a07a2so709571276.2
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 15:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689027533; x=1691619533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eDFdcMVvuSHxkjO2uqvUYkWV9wVwjgAOkT3F/yGpN3I=;
        b=S2cWLS4i8eXUjIgzftrihand6668ir+effAsYqI0LKi7DnY67LnkLDLFjTgKtDmkXQ
         y/x9Rnccs4u+2dZF+rrpBcIdFuMm2rumNfPI213+m5TU8g8XrGOc9eHdPqQBKve2C/h1
         BNH++tgbnW9X/Ik2bw1zX21piXuxGN9oGtJMUUu+rP73xUBEbicADtLGk7sNLgrmTW9x
         e/gmjqnt41ggd7SLNT+CmiMWs4QfSfdJY72XxCGQmTAmA7FfyYfbAq/0PsJLV7BZr3sF
         1Feqbvrvx6Bw1VCBe1gOqfsDko/Fk7NYg5x7qcHRGpuOnlnTOGfgJyFT11uizTOaXrn9
         5QSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689027533; x=1691619533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eDFdcMVvuSHxkjO2uqvUYkWV9wVwjgAOkT3F/yGpN3I=;
        b=W3S65sg3XjxW+b8e1Q+kfo0/k54/WrhnlHji69g7Lx6qtzA0IN/8CFqJXsSFooxrlr
         NOwc+3YRs9wPkbI7fCyFE0ZxG8eTXVoSS7WkuVRwbHyUrpIUc6XxoxvJ2Y7fjsLcUqL6
         6+NX+rJcB8MYm5+PentId05Mz9zHTaloG45dveWe45WirDrRaCmM8U/1i3t530+QZA0n
         KWbEdX6zA7V6NY56Kf6pNibDcIqQWTPKvJGL2nKzSixrOGOTuNfdn5jpp5uucxyhZ04x
         HbCcAuGwFWIH+5GzY/Ut0E9Kj2LMbEeXN8h+GY7ckgl4ojI5JPkZQAj9VWmuCmWfjiAT
         bK0Q==
X-Gm-Message-State: ABy/qLZNo63Y7LQIEHRi+o96PR1U16iaiy8v5FIFdtOY3uNV61z1W31V
        45DYXwUo44MOZE2/3DWer0LMEn5dVys=
X-Google-Smtp-Source: APBJJlHBwAuelcbPV8Qt4MXMJ+iSmG7/6+j2mraC6EjqxInz8sALnUI2SwL0piDPprIWmO+jnK+GQEdWU4M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4907:0:b0:c5e:9e7e:4847 with SMTP id
 w7-20020a254907000000b00c5e9e7e4847mr71157yba.5.1689027533031; Mon, 10 Jul
 2023 15:18:53 -0700 (PDT)
Date:   Mon, 10 Jul 2023 15:18:51 -0700
In-Reply-To: <ffd84a94-abea-a813-a6da-59d45a5ac468@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com> <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
 <ZIyiWr4sR+MqwmAo@google.com> <ffd84a94-abea-a813-a6da-59d45a5ac468@intel.com>
Message-ID: <ZKyDy3IiB/6VHt02@google.com>
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com,
        Gil Neiger <gil.neiger@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023, Weijiang Yang wrote:
> Maybe you need modify above changelog a bit per the update.

Ya, I'll make sure the changelog gets updated before CET support is merged, though
feel free to post the next version without waiting for new changelog.

> Given the updated parts are technical forecast, I don't plan to implement it
> in this series and still enumerate
> 
> CET_SSS ==0 for guest. What's your thoughts?

Yes, definitely punt shadow-stack fixup to future enabling work. 
