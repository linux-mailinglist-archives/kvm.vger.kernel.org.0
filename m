Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5112A610662
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 01:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbiJ0X2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 19:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbiJ0X16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 19:27:58 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A882409D
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 16:27:55 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d24so3287814pls.4
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 16:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M944BwXhmX6ofcxY5WsSeXuDl4+5HoO0sl8zSUCFSpQ=;
        b=l+hbP1DaDTXYg+bYhuotSVusfXnhjMEKWysxKsmD5vd18maH300PiIjC3tlDQNkoPj
         uZHuIHxSlHwRY7vmcjNfftgHiAO8k6pghVhbH+Qc38KDdRkRcfGTP5Pes8YZsQHi2fE8
         Qzma1PbfAnoBhm6dNQqNxMmO8p3Nt9ziji2Zhh/Ls87T3hKB1VspHmyuIJ/GVthCPJwX
         +ZuwluN/LuVlZkBzbyVu1R0n5Fpo8mGJ6+A++WDfC947nL0DxHF4wlKef21Pb1p83/kQ
         pqjXdrqs4/sOlc7c7oa0cCs+hk5CryOpLCTJhlgtYFFMqWFaw33trn0y/LtAumLbjaSO
         E/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M944BwXhmX6ofcxY5WsSeXuDl4+5HoO0sl8zSUCFSpQ=;
        b=LkNQThuktkFaW4iWFviW09d8GNCAzc1rjW3sixPZGtfcpyNGWKPqhwZLp71JM37nLG
         /rJO2uxRAAkiZvwdFBrq5MyV4LZFO8u/xRABnHh6ClccXfMD/0ToV+NiiPFaUtkYDcKF
         BxxVkPR2VuMoTSfXfC+MHfOAeL1Y1UgzaoorgnXvDh6gaRClMOxiFq0Y4Hv1Y4tv4xBT
         2sBNklQQ7qhQzV98U5d0ztw+FEaPpYBTwmGE8S4MjJ0jfU7ODH0YhHdf/kdZPcEX3Y5b
         O/o/8L9m9zVOUucOaYHEs+ZOe1Q+vzeuKrQyF4P9VesS3w8FT9Z8Es84CMdNkKdrknQ+
         BGow==
X-Gm-Message-State: ACrzQf2W4zNHBp5nbzs89AUOmQh+yqy/0bcVqSmucNHDOKDyyqqBYI94
        IJdDkf7vjdRr55tfJ09bUG9KMA==
X-Google-Smtp-Source: AMsMyM7OM3AZ5tJnkJlgRpycRj/bQzj2s9LR1kshY40Fw+rSQZaZ2PKoLvLY5ZTZxmygI3YPoHda1g==
X-Received: by 2002:a17:902:9894:b0:186:a7d7:c56 with SMTP id s20-20020a170902989400b00186a7d70c56mr24343832plp.168.1666913275186;
        Thu, 27 Oct 2022 16:27:55 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h18-20020aa796d2000000b0056bf878eeccsm1684403pfq.47.2022.10.27.16.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 16:27:54 -0700 (PDT)
Date:   Thu, 27 Oct 2022 23:27:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/8] KVM: selftests: Rename emulator_error_test to
 smaller_maxphyaddr_emulation_test
Message-ID: <Y1sT95CzCuvy2/QP@google.com>
References: <20221018214612.3445074-1-dmatlack@google.com>
 <20221018214612.3445074-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018214612.3445074-2-dmatlack@google.com>
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

On Tue, Oct 18, 2022, David Matlack wrote:
> Rename emulator_error_test to smaller_maxphyaddr_emulation_test and
> update the comment at the top of the file to document that this is
> explicitly a test to validate that KVM emulates instructions in response
> to an EPT violation when emulating a smaller MAXPHYADDR.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
