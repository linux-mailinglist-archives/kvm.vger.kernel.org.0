Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241BE509DCC
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 12:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388459AbiDUKkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 06:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236262AbiDUKkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 06:40:40 -0400
Received: from mta-out-06.alice.it (mta-out-06.alice.it [217.169.118.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 247DB25580
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 03:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alice.it; s=20211207; t=1650537470; 
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        h=Reply-To:From:To:Date:Message-ID:MIME-Version;
        b=0lUdpUEps9UfxyRDs4ZTOYLisdgYBPi1GregHfdw7u3h46IrbNKqnV3k/egRiC4fZwKCXeBW1SG8HVBqR3Vo8HxKQqaLFsCKY85uCUwBb8OwAt6s0rNf+wWTIUPXcvdMklXmpjv4OVnFkQb8KGlq2QW5iiiRfo//USoCgg8iPRSYFo/eHNUOd1GuPqGUCe7CjRJUQki4mImmRPsJxNPOLsgi4JNJB8uJLPlJm1baV6T7j7LefPY0tcaEpimKxfODen4qnFpUjU8hPe4n90cNuDdebwgu6yBoQQXie5xndo3hbry/v08KQrsk59bAgxL3+aBMAa7Cf1IG9BXAC2hKIA==
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedvfedrtddvgddvlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfvgffngfevqffokffvtefnkfetpdfqfgfvnecuuegrihhlohhuthemuceftddunecugfhmphhthicushhusghjvggtthculddutddmnefgmhhpthihucgsohguhiculdehtddmnecujfgurheprhfhvfffkfggsedttdeftddttddtnecuhfhrohhmpeghvgcuhhgrvhgvucgrnhcuohhffhgvrhcuthhouchinhhvvghsthcuihhnucihohhurhcutghouhhnthhrhicuuhhnuggvrhcurgcujhhoihhnthcuvhgvnhhtuhhrvgcuphgrrhhtnhgvrhhshhhiphcuphhlvggrshgvuchrvghplhihuchfohhruchmohhrvgcuuggvthgrihhlshcuoegrlhgvkhhosheileesrghlihgtvgdrihhtqeenucggtffrrghtthgvrhhnpeffveffjeduvddthfejlefhhfduiedutdduieefkeekfeeugfdutddtfffffeejfeenucfkphepleehrddvuddurddvuddtrddvfedvnecuvehluhhsthgvrhfuihiivgepudeihedunecurfgrrhgrmhephhgvlhhopegrlhhitggvrdhithdpihhnvghtpeelhedrvdduuddrvddutddrvdefvddpmhgrihhlfhhrohhmpegrlhgvkhhosheileesrghlihgtvgdrihhtpdhnsggprhgtphhtthhopedupdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-RazorGate-Vade-Verdict: clean 60
X-RazorGate-Vade-Classification: clean
Received: from alice.it (95.211.210.232) by mta-out-06.alice.it (5.8.807.04) (authenticated as alekos69@alice.it)
        id 6259240D019C61FE for kvm@vger.kernel.org; Thu, 21 Apr 2022 12:37:46 +0200
Reply-To: dougfield22@inbox.lv
From:   We have an offer to invest in your country under a
         joint venture partnership please reply for more
         details <alekos69@alice.it>
To:     kvm@vger.kernel.org
Date:   21 Apr 2022 03:37:44 -0700
Message-ID: <20220421033744.56B030A278C2FD14@alice.it>
MIME-Version: 1.0
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_40,BODY_EMPTY,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,EMPTY_MESSAGE,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,MISSING_SUBJECT,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_BL,RCVD_IN_MSPIKE_L3,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.7 RCVD_IN_DNSWL_LOW RBL: Sender listed at https://www.dnswl.org/,
        *       low trust
        *      [217.169.118.12 listed in list.dnswl.org]
        * -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
        *      [score: 0.3071]
        *  0.0 RCVD_IN_MSPIKE_L3 RBL: Low reputation (-3)
        *      [217.169.118.12 listed in bl.mailspike.net]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dougfield22[at]inbox.lv]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [alekos69[at]alice.it]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [alekos69[at]alice.it]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  1.8 MISSING_SUBJECT Missing Subject: header
        *  0.0 RCVD_IN_MSPIKE_BL Mailspike blacklisted
        *  2.3 EMPTY_MESSAGE Message appears to have no textual parts and no
        *      Subject: text
        *  0.4 BODY_EMPTY No body text in message
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

