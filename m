Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1182C143B7
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 05:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfEFDVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 May 2019 23:21:07 -0400
Received: from mga04.intel.com ([192.55.52.120]:17126 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfEFDVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 May 2019 23:21:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 May 2019 20:21:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,435,1549958400"; 
   d="asc'?scan'208";a="148880657"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.13.116])
  by fmsmga007.fm.intel.com with ESMTP; 05 May 2019 20:20:59 -0700
Date:   Mon, 6 May 2019 11:20:32 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, arei.gonglei@huawei.com,
        aik@ozlabs.ru, Zhengxiao.zx@alibaba-inc.com,
        shuangtai.tst@alibaba-inc.com, qemu-devel@nongnu.org,
        eauger@redhat.com, yi.l.liu@intel.com, ziye.yang@intel.com,
        mlevitsk@redhat.com, pasic@linux.ibm.com, felipe@nutanix.com,
        changpeng.liu@intel.com, Ken.Xue@amd.com,
        jonathan.davies@nutanix.com, shaopeng.he@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, alex.williamson@redhat.com,
        eskultet@redhat.com, dgilbert@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, cjia@nvidia.com, kwankhede@nvidia.com,
        berrange@redhat.com, dinechin@redhat.com
Subject: Re: [PATCH v2 2/2] drm/i915/gvt: export mdev device version to sysfs
 for Intel vGPU
Message-ID: <20190506032032.GP12913@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20190506014514.3555-1-yan.y.zhao@intel.com>
 <20190506015102.3691-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Pz0BBB9QxoYXlT+x"
Content-Disposition: inline
In-Reply-To: <20190506015102.3691-1-yan.y.zhao@intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Pz0BBB9QxoYXlT+x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019.05.05 21:51:02 -0400, Yan Zhao wrote:
> This feature implements the version attribute for Intel's vGPU mdev
> devices.
>=20
> version attribute is rw.
> It's used to check device compatibility for two mdev devices.
> version string format and length are private for vendor driver. vendor
> driver is able to define them freely.
>=20
> For Intel vGPU of gen8 and gen9, the mdev device version
> consists of 3 fields: "vendor id" + "device id" + "mdev type".
>=20
> Reading from a vGPU's version attribute, a string is returned in below
> format: <vendor id>-<device id>-<mdev type>. e.g.
> 8086-193b-i915-GVTg_V5_2.
>=20
> Writing a string to a vGPU's version attribute will trigger GVT to check
> whether a vGPU identified by the written string is compatible with
> current vGPU owning this version attribute. errno is returned if the two
> vGPUs are incompatible. The length of written string is returned in
> compatible case.
>=20
> For other platforms, and for GVT not supporting vGPU live migration
> feature, errnos are returned when read/write of mdev devices' version
> attributes.
>=20
> For old GVT versions where no version attributes exposed in sysfs, it is
> regarded as not supporting vGPU live migration.
>=20
> For future platforms, besides the current 2 fields in vendor proprietary
> part, more fields may be added to identify Intel vGPU well for live
> migration purpose.
>=20
> v2:
> 1. removed 32 common part of version string
> (Alex Williamson)
> 2. do not register version attribute for GVT not supporting live
> migration.(Cornelia Huck)
> 3. for platforms out of gen8, gen9, return -EINVAL --> -ENODEV for
> incompatible. (Cornelia Huck)
>=20
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Erik Skultety <eskultet@redhat.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: "Tian, Kevin" <kevin.tian@intel.com>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: "Wang, Zhi A" <zhi.a.wang@intel.com>
> c: Neo Jia <cjia@nvidia.com>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
>=20
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/Makefile         |  2 +-
>  drivers/gpu/drm/i915/gvt/device_version.c | 87 +++++++++++++++++++++++
>  drivers/gpu/drm/i915/gvt/gvt.c            | 51 +++++++++++++
>  drivers/gpu/drm/i915/gvt/gvt.h            |  6 ++
>  4 files changed, 145 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/gpu/drm/i915/gvt/device_version.c
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/Makefile b/drivers/gpu/drm/i915/gvt=
/Makefile
> index 271fb46d4dd0..54e209a23899 100644
> --- a/drivers/gpu/drm/i915/gvt/Makefile
> +++ b/drivers/gpu/drm/i915/gvt/Makefile
> @@ -3,7 +3,7 @@ GVT_DIR :=3D gvt
>  GVT_SOURCE :=3D gvt.o aperture_gm.o handlers.o vgpu.o trace_points.o fir=
mware.o \
>  	interrupt.o gtt.o cfg_space.o opregion.o mmio.o display.o edid.o \
>  	execlist.o scheduler.o sched_policy.o mmio_context.o cmd_parser.o debug=
fs.o \
> -	fb_decoder.o dmabuf.o page_track.o
> +	fb_decoder.o dmabuf.o page_track.o device_version.o
> =20
>  ccflags-y				+=3D -I$(src) -I$(src)/$(GVT_DIR)
>  i915-y					+=3D $(addprefix $(GVT_DIR)/, $(GVT_SOURCE))
> diff --git a/drivers/gpu/drm/i915/gvt/device_version.c b/drivers/gpu/drm/=
i915/gvt/device_version.c
> new file mode 100644
> index 000000000000..bd4cdcbdba95
> --- /dev/null
> +++ b/drivers/gpu/drm/i915/gvt/device_version.c
> @@ -0,0 +1,87 @@
> +/*
> + * Copyright(c) 2011-2017 Intel Corporation. All rights reserved.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining=
 a
> + * copy of this software and associated documentation files (the "Softwa=
re"),
> + * to deal in the Software without restriction, including without limita=
tion
> + * the rights to use, copy, modify, merge, publish, distribute, sublicen=
se,
> + * and/or sell copies of the Software, and to permit persons to whom the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice (including the =
next
> + * paragraph) shall be included in all copies or substantial portions of=
 the
> + * Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRE=
SS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILI=
TY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SH=
ALL
> + * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR =
OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISI=
NG FROM,
> + * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALING=
S IN THE
> + * SOFTWARE.
> + *
> + * Authors:
> + *    Yan Zhao <yan.y.zhao@intel.com>
> + */
> +#include <linux/vfio.h>
> +#include "i915_drv.h"
> +
> +static bool is_compatible(const char *self, const char *remote)
> +{
> +	if (strlen(remote) !=3D strlen(self))
> +		return false;
> +
> +	return (strncmp(self, remote, strlen(self))) ? false : true;
> +}
> +
> +ssize_t intel_gvt_get_vfio_device_version_len(struct drm_i915_private *d=
ev_priv)
> +{
> +	if (!IS_GEN(dev_priv, 8) && !IS_GEN(dev_priv, 9))
> +		return -ENODEV;
> +
> +	return PAGE_SIZE;
> +}
> +
> +ssize_t intel_gvt_get_vfio_device_version(struct drm_i915_private *dev_p=
riv,
> +		char *buf, const char *mdev_type)
> +{
> +	int cnt =3D 0, ret =3D 0;
> +	const char *str =3D NULL;
> +

> +	/* currently only gen8 & gen9 are supported */
> +	if (!IS_GEN(dev_priv, 8) && !IS_GEN(dev_priv, 9))
> +		return -ENODEV;
> +
> +	/* vendor id + device id + mdev type */
> +	/* vendor id */
> +	cnt =3D snprintf(buf, 5, "%04x", PCI_VENDOR_ID_INTEL);
> +	buf +=3D cnt;
> +	ret +=3D cnt;
> +
> +	/* device id */
> +	cnt =3D snprintf(buf, 6, "-%04x", INTEL_DEVID(dev_priv));
> +	buf +=3D cnt;
> +	ret +=3D cnt;
> +
> +	/* mdev type */
> +	str =3D mdev_type;
> +	cnt =3D snprintf(buf, strlen(str) + 3, "-%s\n", mdev_type);
> +	buf +=3D cnt;
> +	ret +=3D cnt;
> +
> +	return ret;
> +}
> +
> +ssize_t intel_gvt_check_vfio_device_version(struct drm_i915_private *dev=
_priv,
> +		const char *self, const char *remote)
> +{
> +
> +	/* currently only gen8 & gen9 are supported */
> +	if (!IS_GEN(dev_priv, 8) && !IS_GEN(dev_priv, 9))
> +		return -ENODEV;
> +
> +	if (!is_compatible(self, remote))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.c b/drivers/gpu/drm/i915/gvt/gv=
t.c
> index 43f4242062dd..19f16eec5a4c 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.c
> +++ b/drivers/gpu/drm/i915/gvt/gvt.c
> @@ -105,14 +105,65 @@ static ssize_t description_show(struct kobject *kob=
j, struct device *dev,
>  		       type->weight);
>  }
> =20
> +#ifdef GVT_MIGRATION_VERSION

No extra define.

> +static ssize_t version_show(struct kobject *kobj, struct device *dev,
> +		char *buf)
> +{
> +	struct drm_i915_private *i915 =3D kdev_to_i915(dev);
> +	const char *mdev_type =3D kobject_name(kobj);
> +
> +	return intel_gvt_get_vfio_device_version(i915, buf, mdev_type);
> +}
> +
> +static ssize_t version_store(struct kobject *kobj, struct device *dev,
> +		const char *buf, size_t count)
> +{
> +	char *remote =3D NULL, *self =3D NULL;
> +	int len, ret =3D 0;
> +	struct drm_i915_private *i915 =3D kdev_to_i915(dev);
> +	const char *mdev_type =3D kobject_name(kobj);
> +
> +	len =3D intel_gvt_get_vfio_device_version_len(i915);
> +	if (len < 0)
> +		return len;
> +
> +	self =3D kmalloc(len, GFP_KERNEL);
> +	if (!self)
> +		return -ENOMEM;
> +
> +	ret =3D intel_gvt_get_vfio_device_version(i915, self, mdev_type);
> +	if (ret < 0)
> +		goto out;
> +
> +	remote =3D kstrndup(buf, count, GFP_KERNEL);
> +	if (!remote) {
> +		ret =3D -ENOMEM;
> +		goto out;
> +	}

Please make device version as attribute for vgpu instead of allocating memo=
ry
everytime to generate it.

> +
> +	ret =3D intel_gvt_check_vfio_device_version(i915, self, remote);
> +
> +out:
> +	kfree(self);
> +	kfree(remote);
> +	return (ret < 0 ? ret : count);
> +}
> +#endif
> +
>  static MDEV_TYPE_ATTR_RO(available_instances);
>  static MDEV_TYPE_ATTR_RO(device_api);
>  static MDEV_TYPE_ATTR_RO(description);
> +#ifdef GVT_MIGRATION_VERSION
> +static MDEV_TYPE_ATTR_RW(version);
> +#endif

Don't need extra define.

> =20
>  static struct attribute *gvt_type_attrs[] =3D {
>  	&mdev_type_attr_available_instances.attr,
>  	&mdev_type_attr_device_api.attr,
>  	&mdev_type_attr_description.attr,
> +#ifdef GVT_MIGRATION_VERSION
> +	&mdev_type_attr_version.attr,
> +#endif
>  	NULL,
>  };

I think you need another group of attrs for type that could support
migration, it will be assigned during host init for current platform
with driver support. So just add new group of attrs for like
gvt_migration_type_attrs[] with version.

> =20
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gv=
t.h
> index f5a328b5290a..4062f6b26acf 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.h
> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> @@ -687,6 +687,12 @@ void intel_gvt_debugfs_remove_vgpu(struct intel_vgpu=
 *vgpu);
>  int intel_gvt_debugfs_init(struct intel_gvt *gvt);
>  void intel_gvt_debugfs_clean(struct intel_gvt *gvt);
> =20
> +ssize_t intel_gvt_get_vfio_device_version(struct drm_i915_private *i915,
> +		char *buf, const char *mdev_type);
> +ssize_t intel_gvt_check_vfio_device_version(struct drm_i915_private *dev=
_priv,
> +		const char *self, const char *remote);
> +ssize_t
> +intel_gvt_get_vfio_device_version_len(struct drm_i915_private *dev_priv);
> =20
>  #include "trace.h"
>  #include "mpt.h"
> --=20
> 2.17.1
>=20

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--Pz0BBB9QxoYXlT+x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXM+oAAAKCRCxBBozTXgY
J14wAJ0YjRhnIv19nR6j9t9aD1RZL+CJZQCeMMeABwgHatmsyu6pu4oFZJQmZ2c=
=2bWj
-----END PGP SIGNATURE-----

--Pz0BBB9QxoYXlT+x--
