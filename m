Return-Path: <kvm+bounces-28121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E63EB9943E3
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 11:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D9E61C24714
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 09:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC9A1925B2;
	Tue,  8 Oct 2024 09:14:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228AB191F9A
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 09:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728378872; cv=none; b=XgwwHAGKKOPxxk/hR+Un3SkUrU4ByF+uYj2iqSnc81kyxUU6WG0dmj5DEi+86CinFP68ooZQCSSlIYTnCLB3kL06Kk9zvV9zEVcYyxf0JXxJr2pBTCML/k2YYZbXKu/LVJRxuDjsL6AOTPZhF8cFf1kW5vlNbDRLhdU+OZd7nZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728378872; c=relaxed/simple;
	bh=Z6cYw2Vzmn9FPBnNmzt9hLUeRaiT/IrHGXRJAS0GzPc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J7CSj6FxJs1/xUjfJZ/keSiKhxBmxjrzhyKzHPuxVOWyjQRJY9Diq5C8Brw0r3pP9xb3IPBhkxeQYhZY0T8mkK949kgg8cDHwZFqgtAyc4AyfT49Sp9AjawLbzd+6p3cuyTfBbTDz/jZwCDPtFd41LXaQNO4GDNKgit3VgWS6qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XN9G96KHJz6LDQ6;
	Tue,  8 Oct 2024 17:10:09 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 5EA1A1402C6;
	Tue,  8 Oct 2024 17:14:27 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 8 Oct
 2024 11:14:26 +0200
Date: Tue, 8 Oct 2024 10:14:25 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: "Daniel P . =?ISO-8859-1?Q?Berrang=E9?=" <berrange@redhat.com>, "Igor
 Mammedov" <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Philippe =?ISO-8859-1?Q?Ma?=
 =?ISO-8859-1?Q?thieu-Daud=E9?= <philmd@linaro.org>, Yanan Wang
	<wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Richard Henderson
	<richard.henderson@linaro.org>, Sergio Lopez <slp@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Stefano Stabellini <sstabellini@kernel.org>, "Anthony
 PERARD" <anthony@xenproject.org>, Paul Durrant <paul@xen.org>, "Edgar E .
 Iglesias" <edgar.iglesias@gmail.com>, Eric Blake <eblake@redhat.com>, Markus
 Armbruster <armbru@redhat.com>, Alex =?ISO-8859-1?Q?Benn=E9e?=
	<alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>,
	"Zhenyu Wang" <zhenyu.z.wang@intel.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [RFC v2 01/12] qdev: Allow qdev_device_add() to add specific
 category device
Message-ID: <20241008101425.00003b90@Huawei.com>
In-Reply-To: <20240919061128.769139-2-zhao1.liu@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
	<20240919061128.769139-2-zhao1.liu@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Thu, 19 Sep 2024 14:11:17 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> Topology devices need to be created and realized before board
> initialization.
> 
> Allow qdev_device_add() to specify category to help create topology
> devices early.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
It's not immediately obvious what the category parameter is.
Can you use DeviceCategory rather than long?

> ---
>  hw/net/virtio-net.c    |  2 +-
>  hw/usb/xen-usb.c       |  3 ++-
>  include/monitor/qdev.h |  4 ++--
>  system/qdev-monitor.c  | 12 ++++++++----
>  system/vl.c            |  4 ++--
>  5 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
> index fb84d142ee29..0d92e09e9076 100644
> --- a/hw/net/virtio-net.c
> +++ b/hw/net/virtio-net.c
> @@ -935,7 +935,7 @@ static void failover_add_primary(VirtIONet *n, Error **errp)
>          return;
>      }
>  
> -    dev = qdev_device_add_from_qdict(n->primary_opts,
> +    dev = qdev_device_add_from_qdict(n->primary_opts, NULL,
>                                       n->primary_opts_from_json,
>                                       &err);
>      if (err) {
> diff --git a/hw/usb/xen-usb.c b/hw/usb/xen-usb.c
> index 13901625c0c8..e4168b1fec7e 100644
> --- a/hw/usb/xen-usb.c
> +++ b/hw/usb/xen-usb.c
> @@ -766,7 +766,8 @@ static void usbback_portid_add(struct usbback_info *usbif, unsigned port,
>      qdict_put_str(qdict, "hostport", portname);
>      opts = qemu_opts_from_qdict(qemu_find_opts("device"), qdict,
>                                  &error_abort);
> -    usbif->ports[port - 1].dev = USB_DEVICE(qdev_device_add(opts, &local_err));
> +    usbif->ports[port - 1].dev = USB_DEVICE(
> +                                     qdev_device_add(opts, NULL, &local_err));
>      if (!usbif->ports[port - 1].dev) {
>          qobject_unref(qdict);
>          xen_pv_printf(&usbif->xendev, 0,
> diff --git a/include/monitor/qdev.h b/include/monitor/qdev.h
> index 1d57bf657794..f5fd6e6c1ffc 100644
> --- a/include/monitor/qdev.h
> +++ b/include/monitor/qdev.h
> @@ -8,8 +8,8 @@ void hmp_info_qdm(Monitor *mon, const QDict *qdict);
>  void qmp_device_add(QDict *qdict, QObject **ret_data, Error **errp);
>  
>  int qdev_device_help(QemuOpts *opts);
> -DeviceState *qdev_device_add(QemuOpts *opts, Error **errp);
> -DeviceState *qdev_device_add_from_qdict(const QDict *opts,
> +DeviceState *qdev_device_add(QemuOpts *opts, long *category, Error **errp);
> +DeviceState *qdev_device_add_from_qdict(const QDict *opts, long *category,
>                                          bool from_json, Error **errp);
>  
>  /**
> diff --git a/system/qdev-monitor.c b/system/qdev-monitor.c
> index 457dfd05115e..fe120353fedc 100644
> --- a/system/qdev-monitor.c
> +++ b/system/qdev-monitor.c
> @@ -632,7 +632,7 @@ const char *qdev_set_id(DeviceState *dev, char *id, Error **errp)
>      return prop->name;
>  }
>  
> -DeviceState *qdev_device_add_from_qdict(const QDict *opts,
> +DeviceState *qdev_device_add_from_qdict(const QDict *opts, long *category,
>                                          bool from_json, Error **errp)
>  {
>      ERRP_GUARD();
> @@ -655,6 +655,10 @@ DeviceState *qdev_device_add_from_qdict(const QDict *opts,
>          return NULL;
>      }
>  
> +    if (category && !test_bit(*category, dc->categories)) {
> +        return NULL;
> +    }
> +
>      /* find bus */
>      path = qdict_get_try_str(opts, "bus");
>      if (path != NULL) {
> @@ -767,12 +771,12 @@ err_del_dev:
>  }
>  
>  /* Takes ownership of @opts on success */
> -DeviceState *qdev_device_add(QemuOpts *opts, Error **errp)
> +DeviceState *qdev_device_add(QemuOpts *opts, long *category, Error **errp)
>  {
>      QDict *qdict = qemu_opts_to_qdict(opts, NULL);
>      DeviceState *ret;
>  
> -    ret = qdev_device_add_from_qdict(qdict, false, errp);
> +    ret = qdev_device_add_from_qdict(qdict, category, false, errp);
>      if (ret) {
>          qemu_opts_del(opts);
>      }
> @@ -897,7 +901,7 @@ void qmp_device_add(QDict *qdict, QObject **ret_data, Error **errp)
>          qemu_opts_del(opts);
>          return;
>      }
> -    dev = qdev_device_add(opts, errp);
> +    dev = qdev_device_add(opts, NULL, errp);
>      if (!dev) {
>          /*
>           * Drain all pending RCU callbacks. This is done because
> diff --git a/system/vl.c b/system/vl.c
> index 193e7049ccbe..c40364e2f091 100644
> --- a/system/vl.c
> +++ b/system/vl.c
> @@ -1212,7 +1212,7 @@ static int device_init_func(void *opaque, QemuOpts *opts, Error **errp)
>  {
>      DeviceState *dev;
>  
> -    dev = qdev_device_add(opts, errp);
> +    dev = qdev_device_add(opts, NULL, errp);
>      if (!dev && *errp) {
>          error_report_err(*errp);
>          return -1;
> @@ -2665,7 +2665,7 @@ static void qemu_create_cli_devices(void)
>           * from the start, so call qdev_device_add_from_qdict() directly for
>           * now.
>           */
> -        dev = qdev_device_add_from_qdict(opt->opts, true, &error_fatal);
> +        dev = qdev_device_add_from_qdict(opt->opts, NULL, true, &error_fatal);
>          object_unref(OBJECT(dev));
>          loc_pop(&opt->loc);
>      }


