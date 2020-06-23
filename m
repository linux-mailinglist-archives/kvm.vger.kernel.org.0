Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86060205660
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 17:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733022AbgFWPyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 11:54:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56114 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732986AbgFWPyk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 11:54:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592927678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hkLiUukuiXYIVGoeVwJVWCpKIqIZbdauaKoo+m3/3nA=;
        b=Y6jIt2KFpBShAPPnXvLS4SWze1RLVA3IEajWhpLZ3yz7QK5oRo3go2Pp5ZWJgesy6saotd
        XD7CAhXecBCyy91Ra+CniEH1OEXcZ/TzjvPk3r5XOQJIQ7ndxOlne8Gy1EMvEkZ5IfTqAC
        giOsSEd4Vsqg8mfXiEX5FPV8HLgI6wY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-2-kVLaUUM5WYaYV7UpT8jw-1; Tue, 23 Jun 2020 11:54:37 -0400
X-MC-Unique: 2-kVLaUUM5WYaYV7UpT8jw-1
Received: by mail-qt1-f197.google.com with SMTP id u26so15849429qtj.21
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 08:54:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hkLiUukuiXYIVGoeVwJVWCpKIqIZbdauaKoo+m3/3nA=;
        b=jqzmcX6QZuNmjz8bq5FeE19xuYgMb7IlOlVc0TcvTPD1gnzq+4dJsn0E6kxY29QbPx
         wuSoG+Bwlt385QYW9kmKOLlSJYmqj5To5D9nVmzLlPN8v+Rayl32lhTlterW9gkDSJU+
         jKlcI/N5SATP1uu+C9q5G1XOnbY7r1jN3bfuQKsxVY7jXfS4v94GMXbixE9+1hqoX+gg
         ot/ytxVk2lsX5IeGS9asWxRS+ulKzS+qUqPlJ6v8nFqyJ2Wzy61sVJHUk8Bc7AU5jDpm
         kEv96cjN7rWnndPZC8AH0xzU4ByVRAt6QZ5sNocQioQfhqe/l1LmIpz/go/xBryY0fEv
         z0PA==
X-Gm-Message-State: AOAM530/qzFpEVZfllX0ozjFnRcYrQEKQBVRveKGAUvDY4I/163X8UY6
        MICzPMiWZ0bjPEX3flHOIqOmYNAvvuI8DDs7/SxLsgQJNJ7m/FKAZH5wfsPGulZlV690mFyNTAU
        Mu6tdbhkurWSJlXgibHu9hUVRlgGt
X-Received: by 2002:ad4:4732:: with SMTP id l18mr3784731qvz.208.1592927676568;
        Tue, 23 Jun 2020 08:54:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaMrF3dl8inlInwgi9ZvOstGos06ueqsrxUIfXtsW401PD1wsBXR5y4aT0AAuSJXkN6jcwtfzXMTpt1KtoBl0=
X-Received: by 2002:ad4:4732:: with SMTP id l18mr3784714qvz.208.1592927676350;
 Tue, 23 Jun 2020 08:54:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-3-mst@redhat.com>
 <0332b0cf-cf00-9216-042c-e870efa33626@redhat.com> <20200622115946-mutt-send-email-mst@kernel.org>
 <c56cc86d-a420-79ca-8420-e99db91980fa@redhat.com> <CAJaqyWc3C_Td_SpV97CuemkQH9vH+EL3sGgeWGE82E5gYxZNCA@mail.gmail.com>
 <20200623042456-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200623042456-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Tue, 23 Jun 2020 17:54:00 +0200
Message-ID: <CAJaqyWfKdOUwnG50a1ni=MBEwfM5qp-h+zj1xbT4xUbvKGP5iw@mail.gmail.com>
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 10:25 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Jun 23, 2020 at 09:00:57AM +0200, Eugenio Perez Martin wrote:
> > On Tue, Jun 23, 2020 at 4:51 AM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > >
> > > On 2020/6/23 =E4=B8=8A=E5=8D=8812:00, Michael S. Tsirkin wrote:
> > > > On Wed, Jun 17, 2020 at 11:19:26AM +0800, Jason Wang wrote:
> > > >> On 2020/6/11 =E4=B8=8B=E5=8D=887:34, Michael S. Tsirkin wrote:
> > > >>>    static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
> > > >>>    {
> > > >>>     kfree(vq->descs);
> > > >>> @@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vho=
st_dev *dev)
> > > >>>     for (i =3D 0; i < dev->nvqs; ++i) {
> > > >>>             vq =3D dev->vqs[i];
> > > >>>             vq->max_descs =3D dev->iov_limit;
> > > >>> +           if (vhost_vq_num_batch_descs(vq) < 0) {
> > > >>> +                   return -EINVAL;
> > > >>> +           }
> > > >> This check breaks vdpa which set iov_limit to zero. Consider iov_l=
imit is
> > > >> meaningless to vDPA, I wonder we can skip the test when device doe=
sn't use
> > > >> worker.
> > > >>
> > > >> Thanks
> > > > It doesn't need iovecs at all, right?
> > > >
> > > > -- MST
> > >
> > >
> > > Yes, so we may choose to bypass the iovecs as well.
> > >
> > > Thanks
> > >
> >
> > I think that the kmalloc_array returns ZERO_SIZE_PTR for all of them
> > in that case, so I didn't bother to skip the kmalloc_array parts.
> > Would you prefer to skip them all and let them NULL? Or have I
> > misunderstood what you mean?
> >
> > Thanks!
>
> Sorry about being unclear. I just meant that it seems cleaner
> to check for iov_limit being 0 not for worker thread.

Actually yes, I also think that iov_limit =3D=3D 0 is a better check.
Changing for the next revision if everyone agrees.

Thanks!

>
> --
> MST
>

