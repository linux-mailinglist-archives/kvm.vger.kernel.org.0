Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECAD33F0E2
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 14:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhCQNJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 09:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhCQNJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 09:09:16 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90465C06174A
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 06:09:15 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id p21so2833719lfu.11
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 06:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=iR+9j6X4IdsNNMGzQa1g02Ob4D0KdKa5cMdXP+O+tfs=;
        b=Hzq/Iy6YyJLqPEgJN3t67foL9JXczmyLMma3uqk3FpEKuspMHMgBCoHM6+pTmjdRTf
         rkPrSwSb1kICvvekKITkZEVIMT6SDS2yjToZhTtcRlGBhowe8RKFVi8t54+AlFfNNF10
         wi5n5BEhdrqNiE9so5QR8H1OWmynI4uT7DUivI8TqmNgMR0qOErKzf8rGCDJn63toXbB
         aISL9E2Jp/H4r61TqwZ3K3lXqZz0dQUfvMApgKO4pQAkUu0gIXB22cl8tb+eBTGTXxwT
         jxraRl1QnLoMLoXybIDXiVMLYd5mODv7klza7RPdllpqLaNn23ujmpy5KmK6aozhlJgR
         5MGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=iR+9j6X4IdsNNMGzQa1g02Ob4D0KdKa5cMdXP+O+tfs=;
        b=Gi4Mm+YDH9/HC6IqvPxtxonupXOw3wIUVnb7HZ02346YLOmDrRsKy7hfXlwwb5Q8L2
         qtFrpshsh8J+FbDybkjRjmrBGOG4D0hs//wbO1LP6O1CSBYRpz1QOaN4LpTZ0y+dv333
         lxLYzgqGG4XGTieVPMQPVBbKAK0AA+JKEt5jv3t2K+5FfsH6GH6UQebd5s44ijKyXwH8
         NsJS1mGxR5Iv4GZvZCEFAr3jNEmVNX6jB7MCVwUdEaGc3y9GXdw/Kr2JWYSy9wafdTNn
         icS72zLiJTpX09mOX8jNYouOqIRyVbV6gMsKJmsX3kIJroDO2pQNO9W7lisRLr8/OENS
         eRbg==
X-Gm-Message-State: AOAM532QWFwYGDltnVir7xWHXhrsOaZNfOiwQEM3WYHmtruzQiS38pwo
        xdXehokqn2k+gTjDNj7T0nk=
X-Google-Smtp-Source: ABdhPJyeGC5FhxgSI55n3zKh3OdtnI5WwvmWkWYCClAxdjDyXSGFs68HMDIUh7MKhSrQB3u+abgeVw==
X-Received: by 2002:a19:c3c3:: with SMTP id t186mr2262915lff.596.1615986553913;
        Wed, 17 Mar 2021 06:09:13 -0700 (PDT)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id i185sm3354877lfd.279.2021.03.17.06.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 06:09:13 -0700 (PDT)
Message-ID: <5c1c5682b29558a8d2053b4201fbb135e9a61790.camel@gmail.com>
Subject: Re: [RFC v3 3/5] KVM: implement wire protocol
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com, mst@redhat.com,
        cohuck@redhat.com, john.levon@nutanix.com
Date:   Wed, 17 Mar 2021 06:08:56 -0700
In-Reply-To: <f9b5c5cf-63a4-d085-8c99-8d03d29d3f58@redhat.com>
References: <cover.1613828726.git.eafanasova@gmail.com>
         <dad3d025bcf15ece11d9df0ff685e8ab0a4f2edd.1613828727.git.eafanasova@gmail.com>
         <f9b5c5cf-63a4-d085-8c99-8d03d29d3f58@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-03-09 at 14:19 +0800, Jason Wang wrote:
> On 2021/2/21 8:04 下午, Elena Afanasova wrote:
> > Add ioregionfd blocking read/write operations.
> > 
> > Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> > ---
> > v3:
> >   - change wire protocol license
> >   - remove ioregionfd_cmd info and drop appropriate macros
> >   - fix ioregionfd state machine
> >   - add sizeless ioregions support
> >   - drop redundant check in ioregion_read/write()
> > 
> >   include/uapi/linux/ioregion.h |  30 +++++++
> >   virt/kvm/ioregion.c           | 162
> > +++++++++++++++++++++++++++++++++-
> >   2 files changed, 190 insertions(+), 2 deletions(-)
> >   create mode 100644 include/uapi/linux/ioregion.h
> > 
> > diff --git a/include/uapi/linux/ioregion.h
> > b/include/uapi/linux/ioregion.h
> > new file mode 100644
> > index 000000000000..58f9b5ba6186
> > --- /dev/null
> > +++ b/include/uapi/linux/ioregion.h
> > @@ -0,0 +1,30 @@
> > +/* SPDX-License-Identifier: ((GPL-2.0-only WITH Linux-syscall-
> > note) OR BSD-3-Clause) */
> > +#ifndef _UAPI_LINUX_IOREGION_H
> > +#define _UAPI_LINUX_IOREGION_H
> > +
> > +/* Wire protocol */
> > +
> > +struct ioregionfd_cmd {
> > +	__u8 cmd;
> > +	__u8 size_exponent : 4;
> > +	__u8 resp : 1;
> > +	__u8 padding[6];
> > +	__u64 user_data;
> > +	__u64 offset;
> > +	__u64 data;
> > +};
> 
> Sorry if I've asked this before. Do we need a id for each 
> request/response? E.g an ioregion fd could be used by multiple
> vCPUS. 
> VCPU needs to have a way to find which request belongs to itself or
> not?
> 
I don’t think the id is necessary here since all requests/responses are
serialized.

> 
> > +
> > +struct ioregionfd_resp {
> > +	__u64 data;
> > +	__u8 pad[24];
> > +};
> > +
> > +#define IOREGIONFD_CMD_READ    0
> > +#define IOREGIONFD_CMD_WRITE   1
> > +
> > +#define IOREGIONFD_SIZE_8BIT   0
> > +#define IOREGIONFD_SIZE_16BIT  1
> > +#define IOREGIONFD_SIZE_32BIT  2
> > +#define IOREGIONFD_SIZE_64BIT  3
> > +
> > +#endif
> > diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> > index e09ef3e2c9d7..1e1c7772d274 100644
> > --- a/virt/kvm/ioregion.c
> > +++ b/virt/kvm/ioregion.c
> > @@ -3,6 +3,7 @@
> >   #include <linux/fs.h>
> >   #include <kvm/iodev.h>
> >   #include "eventfd.h"
> > +#include <uapi/linux/ioregion.h>
> >   
> >   void
> >   kvm_ioregionfd_init(struct kvm *kvm)
> > @@ -40,18 +41,175 @@ ioregion_release(struct ioregion *p)
> >   	kfree(p);
> >   }
> >   
> > +static bool
> > +pack_cmd(struct ioregionfd_cmd *cmd, u64 offset, u64 len, u8 opt,
> > u8 resp,
> > +	 u64 user_data, const void *val)
> > +{
> > +	switch (len) {
> > +	case 0:
> > +		break;
> > +	case 1:
> > +		cmd->size_exponent = IOREGIONFD_SIZE_8BIT;
> > +		break;
> > +	case 2:
> > +		cmd->size_exponent = IOREGIONFD_SIZE_16BIT;
> > +		break;
> > +	case 4:
> > +		cmd->size_exponent = IOREGIONFD_SIZE_32BIT;
> > +		break;
> > +	case 8:
> > +		cmd->size_exponent = IOREGIONFD_SIZE_64BIT;
> > +		break;
> > +	default:
> > +		return false;
> > +	}
> > +
> > +	if (val)
> > +		memcpy(&cmd->data, val, len);
> > +	cmd->user_data = user_data;
> > +	cmd->offset = offset;
> > +	cmd->cmd = opt;
> > +	cmd->resp = resp;
> > +
> > +	return true;
> > +}
> > +
> > +enum {
> > +	SEND_CMD,
> > +	GET_REPLY,
> > +	COMPLETE
> > +};
> > +
> > +static void
> > +ioregion_save_ctx(struct kvm_vcpu *vcpu, bool in, gpa_t addr, u8
> > state, void *val)
> > +{
> > +	vcpu->ioregion_ctx.is_interrupted = true;
> > +	vcpu->ioregion_ctx.val = val;
> > +	vcpu->ioregion_ctx.state = state;
> > +	vcpu->ioregion_ctx.addr = addr;
> > +	vcpu->ioregion_ctx.in = in;
> > +}
> > +
> >   static int
> >   ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
> > gpa_t addr,
> >   	      int len, void *val)
> >   {
> > -	return -EOPNOTSUPP;
> > +	struct ioregion *p = to_ioregion(this);
> > +	union {
> > +		struct ioregionfd_cmd cmd;
> > +		struct ioregionfd_resp resp;
> > +	} buf;
> > +	int ret = 0;
> > +	int state = SEND_CMD;
> > +
> > +	if (unlikely(vcpu->ioregion_ctx.is_interrupted)) {
> > +		vcpu->ioregion_ctx.is_interrupted = false;
> > +
> > +		switch (vcpu->ioregion_ctx.state) {
> > +		case SEND_CMD:
> > +			goto send_cmd;
> > +		case GET_REPLY:
> > +			goto get_repl;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +send_cmd:
> > +	memset(&buf, 0, sizeof(buf));
> > +	if (!pack_cmd(&buf.cmd, addr - p->paddr, len,
> > IOREGIONFD_CMD_READ,
> > +		      1, p->user_data, NULL))
> > +		return -EOPNOTSUPP;
> > +
> > +	ret = kernel_write(p->wf, &buf.cmd, sizeof(buf.cmd), 0);
> > +	state = (ret == sizeof(buf.cmd)) ? GET_REPLY : SEND_CMD;
> > +	if (signal_pending(current) && state == SEND_CMD) {
> 
> Can the signal be delivered after a success of kernel_write()? If
> yes, 
> is there any side effect if we want to redo the write here?
> 
Yes, in this case the signal should be handled by KVM. There can be a
side effect when ioregion fd is broken and there is a pending signal
that isn’t related to ioregionfd. But this doesn’t seem to be an issue
since it can be handled later in ioregionfd complete operations.

> 
> > +		ioregion_save_ctx(vcpu, 1, addr, state, val);
> > +		return -EINTR;
> > +	}
> > +	if (ret != sizeof(buf.cmd)) {
> > +		ret = (ret < 0) ? ret : -EIO;
> > +		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ?
> > -EINVAL : ret;
> > +	}
> > +	if (!p->rf)
> > +		return 0;
> > +
> > +get_repl:
> > +	memset(&buf, 0, sizeof(buf));
> > +	ret = kernel_read(p->rf, &buf.resp, sizeof(buf.resp), 0);
> > +	state = (ret == sizeof(buf.resp)) ? COMPLETE : GET_REPLY;
> > +	if (signal_pending(current) && state == GET_REPLY) {
> > +		ioregion_save_ctx(vcpu, 1, addr, state, val);
> > +		return -EINTR;
> > +	}
> > +	if (ret != sizeof(buf.resp)) {
> > +		ret = (ret < 0) ? ret : -EIO;
> > +		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ?
> > -EINVAL : ret;
> > +	}
> 
> We may need to unify the duplicated codes here with send_cmd.
> 
Yes, will refactor.

Thank you
> 
> > +
> > +	memcpy(val, &buf.resp.data, len);
> > +
> > +	return 0;
> >   }
> >   
> >   static int
> >   ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
> > gpa_t addr,
> >   		int len, const void *val)
> >   {
> > -	return -EOPNOTSUPP;
> > +	struct ioregion *p = to_ioregion(this);
> > +	union {
> > +		struct ioregionfd_cmd cmd;
> > +		struct ioregionfd_resp resp;
> > +	} buf;
> > +	int ret = 0;
> > +	int state = SEND_CMD;
> > +
> > +	if (unlikely(vcpu->ioregion_ctx.is_interrupted)) {
> > +		vcpu->ioregion_ctx.is_interrupted = false;
> > +
> > +		switch (vcpu->ioregion_ctx.state) {
> > +		case SEND_CMD:
> > +			goto send_cmd;
> > +		case GET_REPLY:
> > +			goto get_repl;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +send_cmd:
> > +	memset(&buf, 0, sizeof(buf));
> > +	if (!pack_cmd(&buf.cmd, addr - p->paddr, len,
> > IOREGIONFD_CMD_WRITE,
> > +		      p->posted_writes ? 0 : 1, p->user_data, val))
> > +		return -EOPNOTSUPP;
> > +
> > +	ret = kernel_write(p->wf, &buf.cmd, sizeof(buf.cmd), 0);
> > +	state = (ret == sizeof(buf.cmd)) ? GET_REPLY : SEND_CMD;
> > +	if (signal_pending(current) && state == SEND_CMD) {
> > +		ioregion_save_ctx(vcpu, 0, addr, state, (void *)val);
> > +		return -EINTR;
> > +	}
> > +	if (ret != sizeof(buf.cmd)) {
> > +		ret = (ret < 0) ? ret : -EIO;
> > +		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ?
> > -EINVAL : ret;
> > +	}
> > +
> > +get_repl:
> > +	if (!p->posted_writes) {
> > +		memset(&buf, 0, sizeof(buf));
> > +		ret = kernel_read(p->rf, &buf.resp, sizeof(buf.resp),
> > 0);
> > +		state = (ret == sizeof(buf.resp)) ? COMPLETE :
> > GET_REPLY;
> > +		if (signal_pending(current) && state == GET_REPLY) {
> > +			ioregion_save_ctx(vcpu, 0, addr, state, (void
> > *)val);
> > +			return -EINTR;
> > +		}
> > +		if (ret != sizeof(buf.resp)) {
> > +			ret = (ret < 0) ? ret : -EIO;
> > +			return (ret == -EAGAIN || ret == -EWOULDBLOCK)
> > ? -EINVAL : ret;
> > +		}
> > +	}
> > +
> > +	return 0;
> 
> It looks to me we had more chance to unify the code with
> ioregion_read().
> 
> Thanks
> 
> 
> >   }
> >   
> >   /*

