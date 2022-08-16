Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E2A595E0A
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 16:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbiHPOFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 10:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbiHPOEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 10:04:44 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77026BD6B
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 07:04:22 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q16so9315925pgq.6
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 07:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=1GWQeJ3mO/AwsS1RxKEoiTmjiFwoCENhO2G+S4wDDKU=;
        b=MXLWq8Ly9rTmRDyZNuNR3g8mJjeH9dgKfanuaq5Dl7nKAuhvDg5Di203a1rl6HAb+T
         YlWob7XvmiC+vEXV5h0DLNEKpm3HCbMOLbktEzqOagm4T+BV29L94RAjxQy+JAhR7ZpC
         LXT06avUI68wlEHazjn12U/Uhs1ARBLVUwM/Ql4kDcht82pw7Dcmi+ztzDW4iCaytcUV
         nVZN4x8VXjiTgZp/viODvNKL35oVvxR7cBnmX/FXo/Kc+B+gBvP3J6LLMu0IgbS4JlHA
         HyxKdVLgtKE+SHCJdGluZH6jwewFbU10TpkYWSJbkph9tS3ZkEjiLPhQXQk1FrRxB6G5
         Z0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=1GWQeJ3mO/AwsS1RxKEoiTmjiFwoCENhO2G+S4wDDKU=;
        b=cHlVXNfs9lNu7+cvaltQ9Ryhsat4m/sYfIXr1YXxglKvePXUjM4gcAOm0tx/2sg8DK
         oFM20eK/z4tyszujCj8lAX7sd5Ew+9dbRzPCONbtXHntMqD948xRdsTmH5KU3nvQcP0X
         MpQN8PxJDbiMWt7IRrp7YpF4qPvUb9kaEhG9bbPLfQiBC9gcESNP875QkeJdYyrbfIci
         TdZWDWMmIrHD1OLZ9ju6W4oFky8nBHS5nhtEryORiSPgp9P6XUNnFhJPTszoeEldRzcm
         K4gs5z7BFJhZDcdqp5Za3+dxHfzk+7zd68bh0jWJd3nWSpQgBI/LcqtkDSigUKwYazEY
         xNkw==
X-Gm-Message-State: ACgBeo1TLKxoXU4aKbaoVSime0BW1b4Cr/OjoirB8xKmgq3v+/KIsV6J
        QJbPbi3DcJ7QIXeKbJ3PuWEUNQ==
X-Google-Smtp-Source: AA6agR7kLxy5v183YsULCWmOt3IC2ihIF8QYtRU7rFOfEhilKXIu3tcncvsozFV2ULPP1Ik7IBGQUQ==
X-Received: by 2002:a05:6a00:13a7:b0:52e:3139:f895 with SMTP id t39-20020a056a0013a700b0052e3139f895mr20812990pfg.43.1660658662199;
        Tue, 16 Aug 2022 07:04:22 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e15-20020a170902784f00b0016f1c1f50f4sm9109452pln.235.2022.08.16.07.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:04:21 -0700 (PDT)
Date:   Tue, 16 Aug 2022 14:04:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+4f6eb69074ff62a1a33b@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in
 kvm_arch_hardware_enable
Message-ID: <Yvuj4ugWYpthUwhj@google.com>
References: <0000000000009700a805e657c8fa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000009700a805e657c8fa@google.com>
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7ebfc85e2cd7 Merge tag 'net-6.0-rc1' of git://git.kernel.o..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=13d10985080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=20bc0b329895d963
> dashboard link: https://syzkaller.appspot.com/bug?extid=4f6eb69074ff62a1a33b
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1538e0b5080000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112756f3080000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4f6eb69074ff62a1a33b@syzkaller.appspotmail.com

Fix posted[*], apparently the sybot id changes when bugs get forwarded upstream.

[*] https://lore.kernel.org/all/20220816053937.2477106-2-seanjc@google.com
