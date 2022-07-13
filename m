Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE97573560
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 13:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbiGML2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 07:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235560AbiGML2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 07:28:44 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4164B1CFF1;
        Wed, 13 Jul 2022 04:28:43 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r10so8909254wrv.4;
        Wed, 13 Jul 2022 04:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=CnNckbWVu6dnMbMiDPEKHA9YLrVpChrklF3bET8KSwk=;
        b=iqiMQiYMNMPVXdXQf2sJouXsgJiOHZNPyfzS+UBJZV3NwwJ80NrHOYwjulTXyPGVxd
         HXdUs5eDAIN17L7/1xNSGq4R3qvIOyfCQZz3hsCII4joErcTTpVcPIbaNpCXIQklaZgq
         V8bMUPBDStOHGYyMhU8n1tGSfkPLORZMP9KFvk442lPcFJIvjNeV9cYRjEVh0jpAMxqH
         Trp+2m/wyMk3vpI7rFjhtSXpw0bdQQrbPCAlOmBn2Jat5FtTXub7LyBtYWhy2Y/qRtw5
         X9gvG/peRkiAtYMVJXhGlqv2Efgx+z44LrNAZeR6Z1KOE33xPgwPRdVFAXVkQuL5l0+9
         Hbvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=CnNckbWVu6dnMbMiDPEKHA9YLrVpChrklF3bET8KSwk=;
        b=a6FIID9nZ6I8HwDo8atYS6gahXT+Ov12UclDnz0SD0fPT4nMElFNTJr2u5E0C0mHyC
         3G81ZyHYYf6bIFCV5syVvNREhV7/sYhhliYztAdI1HbdLnirFAbOGnmIfNJ7+Cm9y24Q
         H1EM4wf0MG1ko9YyL+9WYbyxX6BJZj6DnOBLMvRy8/lQd9L6cgQcpADEL89pjFi4StWX
         U5NkezoiFvdD68Fl6uQxKlbxnP5wNFBp4ZN3CyXeQS7FJqfC2IGtNsipX+Yd+6ibJWGh
         G7YlRS6lKACz+DTzU5pjRjlQqsbUAlhxTw2Tu1RMbrgfU28NncfcTyI9uyd0LY+P8veh
         ZVKg==
X-Gm-Message-State: AJIora8lCF9mW5tvK1tlYgDv2UvMikxF8ypp2SqqPrNGhh35QLKtmEZa
        Ew5kdyoqU19Q4cOs263JIsg=
X-Google-Smtp-Source: AGRyM1u302WkiFJFFrF03cR8B//2g8BYyz4zgYZzfj4dNWFHNKl5zpy81cNsRsLLT7qQaNxBy5L85w==
X-Received: by 2002:a5d:64e2:0:b0:21d:38e8:2497 with SMTP id g2-20020a5d64e2000000b0021d38e82497mr2648418wri.142.1657711721665;
        Wed, 13 Jul 2022 04:28:41 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id j16-20020adfff90000000b0021d76a1b0e3sm10701868wrr.6.2022.07.13.04.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:28:41 -0700 (PDT)
Date:   Wed, 13 Jul 2022 12:28:38 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: mainline build failure due to fc02735b14ff ("KVM: VMX: Prevent guest
 RSB poisoning attacks with eIBRS")
Message-ID: <Ys6sZj6KYthnDppq@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All,

The latest mainline kernel branch fails to build for x86_64 allmodconfig
with clang and the error is:

arch/x86/kernel/cpu/bugs.c:58:21: error: section attribute is specified on redeclared variable [-Werror,-Wsection]
DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
                    ^
./arch/x86/include/asm/nospec-branch.h:283:12: note: previous declaration is here
extern u64 x86_spec_ctrl_current;


git bisect pointed to fc02735b14ff ("KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS")

I will be happy to test any patch or provide any extra log if needed.

--
Regards
Sudip
