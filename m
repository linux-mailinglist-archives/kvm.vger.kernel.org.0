Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61726947CF
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 15:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjBMORd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 09:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjBMORa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 09:17:30 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B771015545
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 06:17:29 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id d2so12036531pjd.5
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 06:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9KxabtV8Gxta25OgC2D6SS7uLMr9UtHR7eB3HWJjlbE=;
        b=aFq96rao8X/Yiroe/6r3zOWASKc1b6mWcASe6E/G8+ZKRiJjRasU7jzeO2kxtadwri
         MQ2xiGTymNBE5J8wfTmtH4LTR5IP2Y7TjAU8VodzM3wUdN8e/195ItwqfS65zLQ/ugr3
         9I4rgW7es36VL412GAJ/ylWx8k0kc1rK3Eb/M5YNAtTQf9Mwq2X7FNRPttMQNKyJTeOO
         RQY91eGF5UDwbeXrDU5vn8yzc5qtwgrnNvYcuSZg8fqCUyOg8EuJgNtXh26Q4rXapuWw
         XBpcX2gF6XE+LqmoWVZIGa9ZNZnPgjbuTdi9e6ePylWXn1gHleputKOIq+ebObF0g785
         +L8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9KxabtV8Gxta25OgC2D6SS7uLMr9UtHR7eB3HWJjlbE=;
        b=DZnB8ZRnhLDqwFteL1OWM4fT8OjYLiAOyBm4KitK0IQsuogh6YqXkTjghDAGavMqYv
         26F6kVzy8sHzfbV1jolRkyIVCtNQ6DWJmvXN8yrwRrFYZmJJrvL7uIJ9HbZpzel+9r7F
         C9/V9Ugwmp0oPq3LS5oUsI3+Kx7sej71bAhO1wBvnvgwKJL7oZ/jchg+FbOdcyscZ45i
         zXFC9AnRUbnMNOi1CVtrswtZR1aUtjFvSvq14UMFgofkY165E7wboV9gcY8rE5qfvkBl
         5edVnNeP7VuJhToRiabQGnFuEr0RPCHOG/toGZEqW7RgKlwbpubDa0tCYuedOKqQnkSu
         8hmw==
X-Gm-Message-State: AO0yUKWW8ZwwABGOXWo6gWWtbN70tDX4jqVvu936wQ2Eq2JGB86Hbof7
        qfsy84urUsaZjoiUYIrPlwnIb0gHQyJfgJSBYvyhBw==
X-Google-Smtp-Source: AK7set84uOX6lkHYj1JRMvvFpgKFSNkez2K6MuhdS/elvMz+u7N6gQ+j7ymKR+7pQe0UwcN+SOHzY6nqvx7muQnFe2c=
X-Received: by 2002:a17:902:8d8e:b0:19a:8a3c:c6ea with SMTP id
 v14-20020a1709028d8e00b0019a8a3cc6eamr1439721plo.33.1676297849288; Mon, 13
 Feb 2023 06:17:29 -0800 (PST)
MIME-Version: 1.0
References: <20230213025150.71537-1-quintela@redhat.com>
In-Reply-To: <20230213025150.71537-1-quintela@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 13 Feb 2023 14:17:18 +0000
Message-ID: <CAFEAcA9+CdnP_ZTO+WtCqCjm8FSPsRSU82R0mUzZz7Ya3H0Paw@mail.gmail.com>
Subject: Re: [PULL 00/22] Migration 20230213 patches
To:     Juan Quintela <quintela@redhat.com>
Cc:     qemu-devel@nongnu.org,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Li Xiaohui <xiaohli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Feb 2023 at 02:52, Juan Quintela <quintela@redhat.com> wrote:
>
> The following changes since commit 3b33ae48ec28e1e0d1bc28a85c7423724bcb1a2c:
>
>   Merge tag 'block-pull-request' of https://gitlab.com/stefanha/qemu into staging (2023-02-09 15:29:14 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/juan.quintela/qemu.git tags/migration-20230213-pull-request
>
> for you to fetch changes up to 7b548761e5d084f2fc0fc4badebab227b51a8a84:
>
>   ram: Document migration ram flags (2023-02-13 03:45:47 +0100)
>
> ----------------------------------------------------------------
> Migration Pull request (take3)
>
> Hi
>
> In this PULL request:
> - Added to leonardo fixes:
> Fixes: b5eea99ec2 ("migration: Add yank feature")
> Reported-by: Li Xiaohui <xiaohli@redhat.com>
>
> Please apply.


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/8.0
for any user-visible changes.

-- PMM
