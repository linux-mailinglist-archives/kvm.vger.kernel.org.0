Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB7E699EAE
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 22:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjBPVIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 16:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjBPVIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 16:08:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4DE3B86D;
        Thu, 16 Feb 2023 13:08:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 264C260A65;
        Thu, 16 Feb 2023 21:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FADC433D2;
        Thu, 16 Feb 2023 21:08:30 +0000 (UTC)
Date:   Thu, 16 Feb 2023 16:08:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] tools/kvm_stat: use canonical ftrace path
Message-ID: <20230216160828.085c0852@rorschach.local.home>
In-Reply-To: <20230215223350.2658616-5-zwisler@google.com>
References: <20230215223350.2658616-1-zwisler@google.com>
        <20230215223350.2658616-5-zwisler@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Feb 2023 15:33:48 -0700
Ross Zwisler <zwisler@chromium.org> wrote:

> The canonical location for the tracefs filesystem is at /sys/kernel/tracing.
> 
> But, from Documentation/trace/ftrace.rst:
> 
>   Before 4.1, all ftrace tracing control files were within the debugfs
>   file system, which is typically located at /sys/kernel/debug/tracing.
>   For backward compatibility, when mounting the debugfs file system,
>   the tracefs file system will be automatically mounted at:
> 
>   /sys/kernel/debug/tracing
> 
> A comment in kvm_stat still refers to this older debugfs path, so let's
> update it to avoid confusion.
> 
> Signed-off-by: Ross Zwisler <zwisler@google.com>

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
