Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4D4132A99
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 17:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgAGQAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 11:00:43 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42487 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728115AbgAGQAm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jan 2020 11:00:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578412841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2tgaAOxuK+BpANAaDpR2VlivTHiWdjlqBTqnI3DjVok=;
        b=YcQd5OxhDD93m32hoAsJJoehZAPLC2/9IdXjfP+OoZPBljEkOKcm5xF4kfcfVjxsjt//EM
        rBBv7C5GMQc3Nl0PBo8UXgcHQRE3jnCi4FrvxkvWwUQIPHdHq+DjvofrT8bpzIxAitjdvz
        ejxJr7gtSHt/Kc5Ivuv1i2rtXrE+MdU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-sKdw8yQqPsKP1LIUXXHoJw-1; Tue, 07 Jan 2020 11:00:38 -0500
X-MC-Unique: sKdw8yQqPsKP1LIUXXHoJw-1
Received: by mail-qv1-f70.google.com with SMTP id l1so180865qvu.13
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2020 08:00:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2tgaAOxuK+BpANAaDpR2VlivTHiWdjlqBTqnI3DjVok=;
        b=UAVGqWvwfisCBNAtmp9daaJ/xxhY562QdaHLsVuVjN6sGtuhlWq0uDQ/wWK/2RegQB
         QIIABaYV5FOlDtkIh7ph9LoYOxzSVeluIJuGt9bo+sR9p+QnBXkxUwSIS8QGUYf2Z6HC
         Nbw8BJKvzrLbuKgKA+cT6zw4vvVlCRZu7sa6pRk6wO0EV7AirYzV23IutLUfyr/sozOi
         aOOCP0l3lqZgDB22dvqSxwzmrtH9YX9zCDTZmg86LKnHtVwxVUD6dmN8DT4p/FDAjMGJ
         YeBdTFLqrIF0CzqarQCxqW+iqD4gSyQc3VoBFsjbiodHJUj7X26zrGb/1oKHMXotI5OR
         hF6A==
X-Gm-Message-State: APjAAAVxkxyZ9GePqZVsZSXvb+y4mVPhKGm3LOg/SXT7KmSIoWJYdtO1
        P98RAwLNscN9L/0cJVAkHO2d1/WFKYl3xJJTk+fgc2lzM+2U/kOWEOP8cPnrxBS60eDZUsi5Anh
        V3FkYY9gis1Uy
X-Received: by 2002:ad4:5614:: with SMTP id ca20mr77308qvb.43.1578412838067;
        Tue, 07 Jan 2020 08:00:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqxco4tN6LuFo9JPmqxefJvTz1h/hHztoZLdPyxjrU9NmEQbj/K8aPW34C5/taBpDrO7OrLbbw==
X-Received: by 2002:ad4:5614:: with SMTP id ca20mr77269qvb.43.1578412837710;
        Tue, 07 Jan 2020 08:00:37 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id t1sm20365985qkt.129.2020.01.07.08.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 08:00:37 -0800 (PST)
Date:   Tue, 7 Jan 2020 11:00:35 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cannon Matthews <cannonmatthews@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 2/8] KVM: selftests: Add demand paging content to the
 demand paging test
Message-ID: <20200107160035.GG219677@xz-x1>
References: <20191216213901.106941-1-bgardon@google.com>
 <20191216213901.106941-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191216213901.106941-3-bgardon@google.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 01:38:55PM -0800, Ben Gardon wrote:

[...]

> +static void *uffd_handler_thread_fn(void *arg)
> +{
> +	struct uffd_handler_args *uffd_args = (struct uffd_handler_args *)arg;
> +	int uffd = uffd_args->uffd;
> +	int64_t pages = 0;
> +
> +	while (!quit_uffd_thread) {
> +		struct uffd_msg msg;
> +		struct pollfd pollfd[1];
> +		int r;
> +		uint64_t addr;
> +
> +		pollfd[0].fd = uffd;
> +		pollfd[0].events = POLLIN;
> +
> +		/*
> +		 * TODO this introduces a 0.5sec delay at the end of the test.
> +		 * Reduce the timeout or eliminate it following the example in
> +		 * tools/testing/selftests/vm/userfaultfd.c
> +		 */
> +		r = poll(pollfd, 1, 500);

Would you mind implement it instead of adding a todo?  IIUC it's as
simple as a few more lines than the comment itself.  Thanks,

-- 
Peter Xu

