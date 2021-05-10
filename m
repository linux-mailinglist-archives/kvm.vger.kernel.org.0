Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21642379780
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 21:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbhEJTQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 15:16:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51188 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230466AbhEJTQS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 15:16:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620674112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pi7kECIiU4P0HxcADHixR9RjMXJxL4dLTLCibjs6LhI=;
        b=BPIH5ankEDfMWxUiJMXeLijm4vGCoO/O1p9LF47GikZY8nGoJJdZ2pb0GDVz/ol1SiBrtz
        luWEvkgx/4JkbVOTETwDDoYxwciaXAkpHwvXikNca3fajc/OBvGziGqAEFfb1oA36Myr8/
        nzVaps0oND3btuEadlFAPqAldQ3VPd4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-YpVvswbuOoynymhvvpoAZA-1; Mon, 10 May 2021 15:15:05 -0400
X-MC-Unique: YpVvswbuOoynymhvvpoAZA-1
Received: by mail-qk1-f199.google.com with SMTP id l19-20020a37f5130000b02902e3dc23dc92so12417775qkk.15
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 12:15:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pi7kECIiU4P0HxcADHixR9RjMXJxL4dLTLCibjs6LhI=;
        b=WuMYI2WYkKV2j8C26MHBtJFAloSzKDJlYemx7otG7BRrr3bvtOaqN3cz0MjGgtI/Qa
         k5v/8oC8ZYJk4V2TXYiYR5Z4JumS6GzV6mtKRiDmvSrAb5w0tQwibpImq1F5sw2pVBVv
         1GvH1UWz4hMttwcA8DFwhned5Lal1Agbg13l9AFHGAFlIotYLMymARl3l71YIfDfVb7g
         Tb4WBrLefZioP7jby3Ojioo4c5gc4ywOjU2horjRIPkGsUgI8IdYbISZdXUwm08xe/iI
         l+oFOIAcm9hXuKXVhFa1UjU1qFl+G/dO/eqj2ZQPcnbByXfUsbRIB6sCedWZzDWVWBQv
         6FdQ==
X-Gm-Message-State: AOAM531OlFJDxKSCyGVBYPauSLEnJSq67tc6BtRjJALm/xPadObJO4L0
        47Vvo8YTlOR/68u49DVcccvGRMS/ExfQlNf2nXP4vixyTZCjEL+Q3uvMyzf+kyQlHjRPlgMxRWk
        jQBOKoYTzhC26
X-Received: by 2002:ad4:46a9:: with SMTP id br9mr24989753qvb.35.1620674105085;
        Mon, 10 May 2021 12:15:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzC4/Eh4iP6ZZa602M9CC6+dYSn2WTAiLE6ttSzoUgYV0RDFRm5cEJfjmR4gnA1aVPnAwVSOQ==
X-Received: by 2002:ad4:46a9:: with SMTP id br9mr24989722qvb.35.1620674104749;
        Mon, 10 May 2021 12:15:04 -0700 (PDT)
Received: from horse (pool-173-76-174-238.bstnma.fios.verizon.net. [173.76.174.238])
        by smtp.gmail.com with ESMTPSA id 26sm12402346qtd.73.2021.05.10.12.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 12:15:04 -0700 (PDT)
Date:   Mon, 10 May 2021 15:15:02 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Greg Kurz <groug@kaod.org>
Cc:     qemu-devel@nongnu.org, virtio-fs@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [for-6.1 v3 3/3] virtiofsd: Add support for FUSE_SYNCFS request
Message-ID: <20210510191502.GA193692@horse>
References: <20210510155539.998747-1-groug@kaod.org>
 <20210510155539.998747-4-groug@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510155539.998747-4-groug@kaod.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 05:55:39PM +0200, Greg Kurz wrote:
> Honor the expected behavior of syncfs() to synchronously flush all data
> and metadata on linux systems. Simply loop on all known submounts and
> call syncfs() on them.
> 
> Note that syncfs() might suffer from a time penalty if the submounts
> are being hammered by some unrelated workload on the host. The only
> solution to avoid that is to avoid shared submounts.
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>  tools/virtiofsd/fuse_lowlevel.c       | 11 ++++++++
>  tools/virtiofsd/fuse_lowlevel.h       | 12 +++++++++
>  tools/virtiofsd/passthrough_ll.c      | 38 +++++++++++++++++++++++++++
>  tools/virtiofsd/passthrough_seccomp.c |  1 +
>  4 files changed, 62 insertions(+)
> 
> diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
> index 58e32fc96369..3be95ec903c9 100644
> --- a/tools/virtiofsd/fuse_lowlevel.c
> +++ b/tools/virtiofsd/fuse_lowlevel.c
> @@ -1870,6 +1870,16 @@ static void do_lseek(fuse_req_t req, fuse_ino_t nodeid,
>      }
>  }
>  
> +static void do_syncfs(fuse_req_t req, fuse_ino_t nodeid,
> +                      struct fuse_mbuf_iter *iter)
> +{
> +    if (req->se->op.syncfs) {
> +        req->se->op.syncfs(req);
> +    } else {
> +        fuse_reply_err(req, ENOSYS);
> +    }
> +}
> +
>  static void do_init(fuse_req_t req, fuse_ino_t nodeid,
>                      struct fuse_mbuf_iter *iter)
>  {
> @@ -2267,6 +2277,7 @@ static struct {
>      [FUSE_RENAME2] = { do_rename2, "RENAME2" },
>      [FUSE_COPY_FILE_RANGE] = { do_copy_file_range, "COPY_FILE_RANGE" },
>      [FUSE_LSEEK] = { do_lseek, "LSEEK" },
> +    [FUSE_SYNCFS] = { do_syncfs, "SYNCFS" },
>  };
>  
>  #define FUSE_MAXOP (sizeof(fuse_ll_ops) / sizeof(fuse_ll_ops[0]))
> diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
> index 3bf786b03485..890c520b195a 100644
> --- a/tools/virtiofsd/fuse_lowlevel.h
> +++ b/tools/virtiofsd/fuse_lowlevel.h
> @@ -1225,6 +1225,18 @@ struct fuse_lowlevel_ops {
>       */
>      void (*lseek)(fuse_req_t req, fuse_ino_t ino, off_t off, int whence,
>                    struct fuse_file_info *fi);
> +
> +    /**
> +     * Synchronize file system content
> +     *
> +     * If this request is answered with an error code of ENOSYS,
> +     * this is treated as success and future calls to syncfs() will
> +     * succeed automatically without being sent to the filesystem
> +     * process.
> +     *
> +     * @param req request handle
> +     */
> +    void (*syncfs)(fuse_req_t req);
>  };
>  
>  /**
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index dc940a1d048b..289900c6d274 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -3153,6 +3153,43 @@ static void lo_lseek(fuse_req_t req, fuse_ino_t ino, off_t off, int whence,
>      }
>  }
>  
> +static void lo_syncfs(fuse_req_t req)
> +{
> +    struct lo_data *lo = lo_data(req);
> +    GHashTableIter iter;
> +    gpointer key, value;
> +    int err = 0;
> +
> +    pthread_mutex_lock(&lo->mutex);
> +
> +    g_hash_table_iter_init(&iter, lo->mnt_inodes);
> +    while (g_hash_table_iter_next(&iter, &key, &value)) {
> +        struct lo_inode *inode = value;
> +        int fd;
> +
> +        fuse_log(FUSE_LOG_DEBUG, "lo_syncfs(ino=%" PRIu64 ")\n",
> +                 inode->fuse_ino);
> +
> +        fd = lo_inode_open(lo, inode, O_RDONLY);
> +        if (fd < 0) {
> +            err = -fd;
> +            break;
> +        }
> +
> +        if (syncfs(fd) < 0) {

I don't have a good feeling about calling syncfs() with lo->mutex held.
This seems to be that global mutex which is held at so many places
and will serialize everything else. I think we agreed that syncfs()
can take 10s of seconds if fs is busy. And that means we will stall
other filesystem operations too.

So will be good if we can call syncfs() outside the lock. May be prepare
a list of inodes which are there, take a reference and drop the lock.
call syncfs and then drop the reference on inode.

Vivek

> +            err = errno;
> +            close(fd);
> +            break;
> +        }
> +
> +        close(fd);
> +    }
> +
> +    pthread_mutex_unlock(&lo->mutex);
> +
> +    fuse_reply_err(req, err);
> +}
> +
>  static void lo_destroy(void *userdata)
>  {
>      struct lo_data *lo = (struct lo_data *)userdata;
> @@ -3214,6 +3251,7 @@ static struct fuse_lowlevel_ops lo_oper = {
>      .copy_file_range = lo_copy_file_range,
>  #endif
>      .lseek = lo_lseek,
> +    .syncfs = lo_syncfs,
>      .destroy = lo_destroy,
>  };
>  
> diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
> index 62441cfcdb95..343188447901 100644
> --- a/tools/virtiofsd/passthrough_seccomp.c
> +++ b/tools/virtiofsd/passthrough_seccomp.c
> @@ -107,6 +107,7 @@ static const int syscall_allowlist[] = {
>      SCMP_SYS(set_robust_list),
>      SCMP_SYS(setxattr),
>      SCMP_SYS(symlinkat),
> +    SCMP_SYS(syncfs),
>      SCMP_SYS(time), /* Rarely needed, except on static builds */
>      SCMP_SYS(tgkill),
>      SCMP_SYS(unlinkat),
> -- 
> 2.26.3
> 

