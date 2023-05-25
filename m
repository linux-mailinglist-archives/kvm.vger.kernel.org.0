Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98C2711AD6
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 01:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241839AbjEYXrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 19:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbjEYXru (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 19:47:50 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BA3134
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 16:47:48 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f44c25595so58373a12.2
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 16:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685058468; x=1687650468;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M8oZjjOQNTxB16i/kRUTHOPkmBlz5h8b4Y2tKsSoEHg=;
        b=MNBjwkcoIzvJgFY6T3LrC/fvrFsCSV153itbyffZ0Qu+QsnPCQZsCUVrZz0DhJEGYA
         YsamDAjKloHsF7toJ7bkmnLcTj1ZYkXRSLmC7Nomv3jSSPfxuxLjUVFmYbwjB4qZh9Mw
         XGh+2WTytNy0Di7jJ+UpcMPCBvHg0dnXNRFIt0wUADaJwv57St8sYL8lhpOThGQr+obf
         kcykJtmI/XFz16Z2PG8Mj9nVgfDPgzGzOBTorX3YfZ1Uwsk9Aw1NFEoVi1+A41OhX108
         EuJ0me8RDDDnRzMbTTgWnOhq87ol54ILYp5QhM6Jv7ftzfF0tkQ+v2fj6SotuIMyD4hD
         ua1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685058468; x=1687650468;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M8oZjjOQNTxB16i/kRUTHOPkmBlz5h8b4Y2tKsSoEHg=;
        b=adKSl2xGKVKOBn0DioWxYL1kOa06wwaQB/SQZA+WPC8eN7yXbWfk1yWB1qVF87+sqq
         QBuqVYsN29fycIheeyLV3wkwSTKS2wixi2Om03cpm7gaNf0qDniuJbdcT1DnzwfrBqUk
         VKssde5Yk/Kr2xyIcyZxiyhjim1d892lex/ZFhj6h8N5pAjTsKFmMLXK4yrdqG6Wjy//
         mvQhk5GRxaSlG2TuzC3sPjei3CtNvSYIrg4k+DL7XDhMBwKN6mjxlFbQuS8oi9Qx82KH
         aAfTNO+fUzApyDRl5+87yTP1Uqb9rg4be+X2Sfe4kkgHGO8b2RLBQGbXOSoocCmNzgbr
         76fg==
X-Gm-Message-State: AC+VfDwSkRpiqYuaFnG0MRehuL0kGMqn8AYZ/1CTUID2tRTGg8AnbZpT
        GUxUchmFBxPPMTZXEPib5ts2jsuVreitYAM8iCAcVuzFK8x4ahT22lQTbq0k4YBvViZLNjfILgs
        teiHdhfEhhMdWWD3dICOB3WmWE/z50S/+tFi08rLRSLKBM7eblBgfQXOFEw==
X-Google-Smtp-Source: ACHHUZ4OPUblLzQ+wnZNi8Hq07X/nDUw9V/Iv71hqqBmrxuykMHf/+umYn8Wea2JDB80fH2D3OsHLU0Jp7o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:192:0:b0:517:ce37:756e with SMTP id
 140-20020a630192000000b00517ce37756emr78680pgb.7.1685058467851; Thu, 25 May
 2023 16:47:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 May 2023 16:47:35 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230525234735.2585977-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.05.31 - guest_memfd()
From:   Sean Christopherson <seanjc@google.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sagi Shahar <sagis@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Anish Ghulati <aghulati@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Babu Moger <babu.moger@amd.com>, Chao Gao <chao.gao@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Guang Zeng <guang.zeng@intel.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Jing Liu <jing2.liu@intel.com>,
        Junaid Shahid <junaids@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Leonardo Bras <leobras@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Li RongQing <lirongqing@baidu.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Michal Luczaj <mhal@rbox.co>,
        Mingwei Zhang <mizhang@google.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Paul Durrant <pdurrant@amazon.com>,
        Peng Hao <flyingpenghao@gmail.com>,
        Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
        Robert Hoo <robert.hu@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Qinglan Xiang <qinglan.xiang@intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Margarita Maroto <margarita.maroto@intel.com>,
        Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Nagareddy Reddy <nspreddy@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Topic:      guest_memfd(), a.k.a. restrictedmem, a.k.a. UPM
Objective:  Reach consensus on design for backing guest private memory
Background: https://lore.kernel.org/all/ZEM5Zq8oo+xnApW9@google.com

Date:  2023.05.31 (May 31st)
Time:  6am PDT
Video: https://meet.google.com/vdb-aeqo-knk
Phone: https://tel.meet/vdb-aeqo-knk?pin=3003112178656

Future Schedule:
June 7th  - pKVM on x86 (Google + Intel)
June 14th - Available!
June 21st - No Meeting (Sean OOO)
June 28th - Available!
July 5th  - No Meeting (Sean OOO)

I've created a shared calendar (comically long link at the bottom) that people
can subscribe to in order to get reminders, notifications, etc.  At least, that's
the theory.  Holler if it's not working as intended and/or if it's insufficient.

Contact me (off-list or on-list, your choice) if you have a topic you'd like to
discuss (see above for available dates).  I can't promise that I'll accept all
proposed topics, but at this point the future schedule is quite open :-)  When
proposing a topic, please provide background info/links and a clear statement on
exactly what you hope to achieve, e.g. if the goal is to get help solving a
technical problem, get feedback on a direction, reach consensus on something, etc.

My goal is to make PUCK as interactive and informal as possible.  To that end,
formal presentations are discouraged, but not outright banned.  Though if you
show up with a big slide deck, I may kick you out of the meeting on principal :-).

Time slots are very flexible (within the 1 hour hard limit), but please try to
make a semi-accurate estimate of how much time a topic will need.  If there is
unclaimed/unused time (or even no topic) for a given instance, my plan is to use
the time for "office hours", e.g. to answer general upstreaming questions, etc.
At this point, I'm not planning on canceling instances if there's no topic, i.e.
will still hold office hours, though that may change if the office hours idea
isn't useful.

People on the Cc list: for my own sanity, future announcements will be sent only
to kvm@ and LKML.  Please either subscribe to the KVM mailing list or the shared
calendar below (or bribe someone to forward you announcements) if you want notificatons.

https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
