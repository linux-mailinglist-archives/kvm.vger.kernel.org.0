Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84340757CF5
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 15:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbjGRNLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 09:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjGRNLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 09:11:03 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C39711C;
        Tue, 18 Jul 2023 06:10:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 155432C0;
        Tue, 18 Jul 2023 13:10:56 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 155432C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1689685856; bh=0GT+AczLIzSdL6o+KeavY53AS3mDNk1ztq/9IRI68V8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=MTcrpAdoNzbS+jQJQGL5uqyZJfpgsvjoqknZQJjd94zuwwoSaKfDmp/RuEa6hCk2g
         +PbbvkMItZSLinaXZAcfG4Ry78tkg2a/610texWE3zeFWngnsL0jKcpYYmTK5AprGd
         +gZvAFsQ0G9fbF0MBWhIoyisTXAKmo9r2vtHnjrj1ZQyODAuJ703Kh4pXuPqd28kLn
         ZyGh/kyCZhG37/yMaTPbSAdthlTfF0ARiE6kzb8GDxP6ra43qCxUIQVnfsifd2zVtR
         MqjnCE/HdHTuAvSUGqRTZrJOjLEVBH58F2VBhF2qdF9JbuBKc7sugTJVXABdmZVvrk
         YgeM7jyA5AHMA==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Heiko Carstens <hca@linux.ibm.com>,
        Costa Shulyupin <costa.shul@redhat.com>
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vineet Gupta <vgupta@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Eric DeVolder <eric.devolder@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:S390 ARCHITECTURE" <linux-s390@vger.kernel.org>,
        "open list:S390 VFIO-CCW DRIVER" <kvm@vger.kernel.org>
Subject: Re: [PATCH] docs: move s390 under arch
In-Reply-To: <ZLYxVo5/YjjOd3i7@osiris>
References: <20230718045550.495428-1-costa.shul@redhat.com>
 <ZLYxVo5/YjjOd3i7@osiris>
Date:   Tue, 18 Jul 2023 07:10:55 -0600
Message-ID: <874jm1uzz4.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Heiko Carstens <hca@linux.ibm.com> writes:

> I guess this should go via Jonathan, like most (or all) other similar
> patches? Jonathan, let me know if you pick this up, or if this should
> go via the s390 tree.

I'm happy either way...I'd sort of thought these would go through the
arch trees to minimize the conflict potential, but it hasn't happened
that way yet.  Let me know your preference and I'll go with it...should
you take it:

Acked-by: Jonathan Corbet <corbet@lwn.net>

Thanks,

jon
