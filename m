Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BC31F9CB4
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 18:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbgFOQLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 12:11:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36730 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728585AbgFOQLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 12:11:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592237505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s3Y9+xXDyttebs3/fVIigjv1aP9MsZuTcGKyOjbOlrk=;
        b=YmaVmkcP5LMJIaOpeQkA1Fg4F6PaFioXjCpd/oBDFIW9p6EtwSbrYfOWqGRqQZELvXUdLw
        W6YnM1ysiB39jALjV2EHeqILrdPks52f9QB7pd+TPnajg8l2CudnlDTj4j53y35QD0sYWP
        +tCUy37exrUAzyII6b3TKfvP77Us07M=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-aO9s3DS0Pna3j0jrU3KiOQ-1; Mon, 15 Jun 2020 12:11:42 -0400
X-MC-Unique: aO9s3DS0Pna3j0jrU3KiOQ-1
Received: by mail-qv1-f72.google.com with SMTP id y2so13446040qvp.1
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 09:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s3Y9+xXDyttebs3/fVIigjv1aP9MsZuTcGKyOjbOlrk=;
        b=QYTpVVQ+fdNXLPHTHhXj96gjfTuDDUw4UMcbisZSWCWbmJhP7gE9cm1LqgQqDHY/yn
         wXtz8+D2Vhe0c6DBF4LxSaU8SrDuoQeWNRV3dmC0iDBxUY3ubcyCnh3cMTJz5fl46OtJ
         YySk6Utmp816+b3e8Fr707p0PUxKV5JdvPoAQchxgFl9FmaPt00NkOlqzUl1RDRcGAh0
         HJDPJs9hucyJcPrOOmt800v41rlil03LKVcFBTqH0fE2ljvouboDfNSvNlr2A+ohJNXp
         zBVTAut2k0nGL0hXuJbyx6IQGHtJT1RxSoibyb+X3D1rhM1HXV0QQmvfLO/zjHR/DLW4
         h19g==
X-Gm-Message-State: AOAM531yq7fIjNs0eTtqJ4USkTRn+5m3vWQREKrx+60SWCn3gX2N3eKM
        3UTixRUeb7fqctyhPY/ir814H83Y44SFZxpZmsJEc/Ho7t6V15VfdCmNw+eAjV7pNWsXTWB3pBe
        52KmTvxjfDEKwrKRmRZ03jgwzuIQg
X-Received: by 2002:ac8:312e:: with SMTP id g43mr16444497qtb.308.1592237502357;
        Mon, 15 Jun 2020 09:11:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJf2dKPK+iYSVWjob0YFgJrsLx4Y6zwMor0rx3TpwaUzXHN6d9uezxdspNtpgbkwdstqV1JKgXVMQuYTR4Z48=
X-Received: by 2002:ac8:312e:: with SMTP id g43mr16444416qtb.308.1592237501400;
 Mon, 15 Jun 2020 09:11:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-6-mst@redhat.com>
In-Reply-To: <20200611113404.17810-6-mst@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 15 Jun 2020 18:11:05 +0200
Message-ID: <CAJaqyWeEdydJu6=Mxptgi0doiCBVS9pF9pg39FMcy1-8jN9G9Q@mail.gmail.com>
Subject: Re: [PATCH RFC v8 05/11] vhost: format-independent API for used buffers
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 1:34 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> Add a new API that doesn't assume used ring, heads, etc.
> For now, we keep the old APIs around to make it easier
> to convert drivers.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/vhost.c | 73 +++++++++++++++++++++++++++++++++++++------
>  drivers/vhost/vhost.h | 17 +++++++++-
>  2 files changed, 79 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index c38605b01080..03e6bca02288 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2335,13 +2335,12 @@ static void unfetch_descs(struct vhost_virtqueue *vq)
>   * number of output then some number of input descriptors, it's actually two
>   * iovecs, but we pack them into one and note how many of each there were.
>   *
> - * This function returns the descriptor number found, or vq->num (which is
> - * never a valid descriptor number) if none was found.  A negative code is
> - * returned on error. */
> -int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> -                     struct iovec iov[], unsigned int iov_size,
> -                     unsigned int *out_num, unsigned int *in_num,
> -                     struct vhost_log *log, unsigned int *log_num)
> + * This function returns a value > 0 if a descriptor was found, or 0 if none were found.
> + * A negative code is returned on error. */
> +int vhost_get_avail_buf(struct vhost_virtqueue *vq, struct vhost_buf *buf,
> +                       struct iovec iov[], unsigned int iov_size,
> +                       unsigned int *out_num, unsigned int *in_num,
> +                       struct vhost_log *log, unsigned int *log_num)
>  {
>         int ret = fetch_descs(vq);
>         int i;
> @@ -2354,6 +2353,8 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>         *out_num = *in_num = 0;
>         if (unlikely(log))
>                 *log_num = 0;
> +       buf->in_len = buf->out_len = 0;
> +       buf->descs = 0;
>
>         for (i = vq->first_desc; i < vq->ndescs; ++i) {
>                 unsigned iov_count = *in_num + *out_num;
> @@ -2383,6 +2384,7 @@ int (struct vhost_virtqueue *vq,
>                         /* If this is an input descriptor,
>                          * increment that count. */
>                         *in_num += ret;
> +                       buf->in_len += desc->len;
>                         if (unlikely(log && ret)) {
>                                 log[*log_num].addr = desc->addr;
>                                 log[*log_num].len = desc->len;
> @@ -2398,9 +2400,11 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>                                 goto err;
>                         }
>                         *out_num += ret;
> +                       buf->out_len += desc->len;
>                 }
>
> -               ret = desc->id;
> +               buf->id = desc->id;
> +               ++buf->descs;
>
>                 if (!(desc->flags & VRING_DESC_F_NEXT))
>                         break;
> @@ -2408,12 +2412,41 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>
>         vq->first_desc = i + 1;
>
> -       return ret;
> +       return 1;
>
>  err:
>         unfetch_descs(vq);
>
> -       return ret ? ret : vq->num;
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(vhost_get_avail_buf);
> +
> +/* Reverse the effect of vhost_get_avail_buf. Useful for error handling. */
> +void vhost_discard_avail_bufs(struct vhost_virtqueue *vq,
> +                             struct vhost_buf *buf, unsigned count)
> +{
> +       vhost_discard_vq_desc(vq, count);
> +}
> +EXPORT_SYMBOL_GPL(vhost_discard_avail_bufs);
> +
> +/* This function returns the descriptor number found, or vq->num (which is
> + * never a valid descriptor number) if none was found.  A negative code is
> + * returned on error. */
> +int vhost_get_vq_desc(struct vhost_virtqueue *vq,
> +                     struct iovec iov[], unsigned int iov_size,
> +                     unsigned int *out_num, unsigned int *in_num,
> +                     struct vhost_log *log, unsigned int *log_num)
> +{
> +       struct vhost_buf buf;
> +       int ret = vhost_get_avail_buf(vq, &buf,
> +                                     iov, iov_size, out_num, in_num,
> +                                     log, log_num);
> +
> +       if (likely(ret > 0))
> +               return buf->id;

This should be buf.id, isn't it?

> +       if (likely(!ret))
> +               return vq->num;
> +       return ret;
>  }
>  EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
>
> @@ -2507,6 +2540,26 @@ int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
>  }
>  EXPORT_SYMBOL_GPL(vhost_add_used);
>
> +int vhost_put_used_buf(struct vhost_virtqueue *vq, struct vhost_buf *buf)
> +{
> +       return vhost_add_used(vq, buf->id, buf->in_len);
> +}
> +EXPORT_SYMBOL_GPL(vhost_put_used_buf);
> +
> +int vhost_put_used_n_bufs(struct vhost_virtqueue *vq,
> +                         struct vhost_buf *bufs, unsigned count)
> +{
> +       unsigned i;
> +
> +       for (i = 0; i < count; ++i) {
> +               vq->heads[i].id = cpu_to_vhost32(vq, bufs[i].id);
> +               vq->heads[i].len = cpu_to_vhost32(vq, bufs[i].in_len);
> +       }
> +
> +       return vhost_add_used_n(vq, vq->heads, count);
> +}
> +EXPORT_SYMBOL_GPL(vhost_put_used_n_bufs);
> +
>  static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
>  {
>         __u16 old, new;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index fed36af5c444..28eea0155efb 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -67,6 +67,13 @@ struct vhost_desc {
>         u16 id;
>  };
>
> +struct vhost_buf {
> +       u32 out_len;
> +       u32 in_len;
> +       u16 descs;
> +       u16 id;
> +};
> +
>  /* The virtqueue structure describes a queue attached to a device. */
>  struct vhost_virtqueue {
>         struct vhost_dev *dev;
> @@ -195,7 +202,12 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
>                       unsigned int *out_num, unsigned int *in_num,
>                       struct vhost_log *log, unsigned int *log_num);
>  void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
> -
> +int vhost_get_avail_buf(struct vhost_virtqueue *, struct vhost_buf *buf,
> +                       struct iovec iov[], unsigned int iov_count,
> +                       unsigned int *out_num, unsigned int *in_num,
> +                       struct vhost_log *log, unsigned int *log_num);
> +void vhost_discard_avail_bufs(struct vhost_virtqueue *,
> +                             struct vhost_buf *, unsigned count);
>  int vhost_vq_init_access(struct vhost_virtqueue *);
>  int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
>  int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
> @@ -204,6 +216,9 @@ void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
>                                unsigned int id, int len);
>  void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
>                                struct vring_used_elem *heads, unsigned count);
> +int vhost_put_used_buf(struct vhost_virtqueue *, struct vhost_buf *buf);
> +int vhost_put_used_n_bufs(struct vhost_virtqueue *,
> +                         struct vhost_buf *bufs, unsigned count);
>  void vhost_signal(struct vhost_dev *, struct vhost_virtqueue *);
>  void vhost_disable_notify(struct vhost_dev *, struct vhost_virtqueue *);
>  bool vhost_vq_avail_empty(struct vhost_dev *, struct vhost_virtqueue *);
> --
> MST
>

