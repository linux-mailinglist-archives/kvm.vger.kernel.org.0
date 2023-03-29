Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D256CDB54
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 15:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjC2N6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 09:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjC2N62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 09:58:28 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C81E5264
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 06:58:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E6794219E8;
        Wed, 29 Mar 2023 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680098302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=95YmYhA7ki+TZC4T3l9Mr5muPYJroIXUV9t1BWvU/2E=;
        b=Gq+mnb1JfEitGhapUj7FK7mZpU+Xx08N6ihNcNSUmmRhrEDeX5IX5rO3mlbwlg7+x2E5IH
        S5PNjTZ95Wuuag/oVErhHv4XiJueY7Im025nHsobi9VYPOnACPQU+joPtcZp2WowW9YN/O
        2eEzLzNrE6oiUtw11YFEFryaV86S1fw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680098302;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=95YmYhA7ki+TZC4T3l9Mr5muPYJroIXUV9t1BWvU/2E=;
        b=J97+9T98Z6FPs4nNyGEWVKcCxRt8GKLT/wF/YDjGrAUbN4FcJfOOxCZ0HejscxaDkV4zXS
        biE/DhAUdcKuphAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6A9B1138FF;
        Wed, 29 Mar 2023 13:58:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id um1fDP5DJGQoJQAAMHmgww
        (envelope-from <farosas@suse.de>); Wed, 29 Mar 2023 13:58:22 +0000
From:   Fabiano Rosas <farosas@suse.de>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org, Yanan Wang <wangyanan55@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, qemu-arm@nongnu.org,
        Philippe =?utf-8?Q?Mathieu-Da?= =?utf-8?Q?ud=C3=A9?= 
        <philmd@linaro.org>,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>
Subject: Re: [PATCH-for-8.0 v2 2/3] softmmu/watchpoint: Add missing
 'qemu/error-report.h' include
In-Reply-To: <20230328173117.15226-3-philmd@linaro.org>
References: <20230328173117.15226-1-philmd@linaro.org>
 <20230328173117.15226-3-philmd@linaro.org>
Date:   Wed, 29 Mar 2023 10:58:19 -0300
Message-ID: <87sfdny804.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> cpu_watchpoint_insert() calls error_report() which is declared
> in "qemu/error-report.h". When moving this code in commit 2609ec2868
> ("softmmu: Extract watchpoint API from physmem.c") we neglected to
> include this header. This works so far because it is indirectly
> included by TCG headers -> "qemu/plugin.h" -> "qemu/error-report.h".
>
> Currently cpu_watchpoint_insert() is only built with the TCG
> accelerator. When building it with other ones (or without TCG)
> we get:
>
>   softmmu/watchpoint.c:38:9: error: implicit declaration of function 'err=
or_report' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
>         error_report("tried to set invalid watchpoint at %"
>         ^
>
> Include "qemu/error-report.h" in order to fix this for non-TCG
> builds.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Reviewed-by: Fabiano Rosas <farosas@suse.de>
