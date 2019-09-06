Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF841AC236
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 23:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404562AbfIFVuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 17:50:07 -0400
Received: from m4a0040g.houston.softwaregrp.com ([15.124.2.86]:36727 "EHLO
        m4a0040g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404236AbfIFVuH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Sep 2019 17:50:07 -0400
Received: FROM m4a0040g.houston.softwaregrp.com (15.120.17.146) BY m4a0040g.houston.softwaregrp.com WITH ESMTP;
 Fri,  6 Sep 2019 21:49:11 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 6 Sep 2019 21:49:46 +0000
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (15.124.72.13) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Fri, 6 Sep 2019 21:49:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIjcHWlC6ui9NKqIjmt31x1bnOBfPKUYDw9TJquG019MZK4YSY4j2eCK/csRVgg9J3VMkY9QmV05uS2A6DRJUsFT7V8apyEeKdt+Cdv9bR7IliubON+qVTaIRsYXkqTj6cjCXJlKbJKpx8eHl/ECV6Q5V4AR+30Ltfo/RBA8V6vsqm0BGGnmg2JA3ekz2NglmTiCHl7IOQfyHA6KuvQYpqq87J0hzdjP9VA1DiGnA2JjNs3LS7DXXGSnGesb7LbFYiVv8f2xXyjKlcRQpIevfbB9FB5M9shZ4P0CSDca+dlS0aX2w+0ww1gZDdUzsDPtnpaeyfVBGvUaBbACz0sCig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMnwe30YAboUDgS0mMXgXqP6Xu66i0zKXlvrRcSjEwk=;
 b=mA41dFT6WPQx9GQ9Xl+59xjnDspGk7zEvjDYLMsW73v90NfDhnLLzz9jwBN3Me/n5UtatFWdtCsjId0uXvyiUDepkeUMOFnfLDPEtFAQiqJqZeRE1TUFl/xnSjRQK3Aj8lNMDfbmBaGtROOygjP1U/5W6gX/FU9P7O1Nog/UcrnTPTgGSIGqRbD9kAzfeWyW87NCeztQHb/rVI5N0cS3LK5ANRlmzTILlG10o/q4hwLEU/zJJGNn0BFExa1FOWMyOPEYVAGacJUv6wNkuXCHNV1Nj4McNySOBgyknHs7oD/dVuo9sWPEPIgFKsSn4hxnKh4khFaKp9YNQTr+f8VtAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from BYAPR18MB3031.namprd18.prod.outlook.com (20.179.94.209) by
 BYAPR18MB2982.namprd18.prod.outlook.com (20.179.60.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Fri, 6 Sep 2019 21:49:44 +0000
Received: from BYAPR18MB3031.namprd18.prod.outlook.com
 ([fe80::6d4c:fa5a:cef9:d2a0]) by BYAPR18MB3031.namprd18.prod.outlook.com
 ([fe80::6d4c:fa5a:cef9:d2a0%6]) with mapi id 15.20.2220.022; Fri, 6 Sep 2019
 21:49:44 +0000
From:   Larry Dewey <ldewey@suse.com>
To:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC PATCH 03/20] vl: Add "sgx-epc" option to expose
 SGX EPC sections to guest
Thread-Topic: [Qemu-devel] [RFC PATCH 03/20] vl: Add "sgx-epc" option to
 expose SGX EPC sections to guest
Thread-Index: AQHVTIoOBKS5WxZgTEykgSwPzRE+RqcfYNoA
Date:   Fri, 6 Sep 2019 21:49:44 +0000
Message-ID: <0be06fee919426129b2f379609f76bd260fba49c.camel@suse.com>
References: <20190806185649.2476-1-sean.j.christopherson@intel.com>
         <20190806185649.2476-4-sean.j.christopherson@intel.com>
In-Reply-To: <20190806185649.2476-4-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldewey@suse.com; 
x-originating-ip: [2605:a601:a96a:bd00:18c9:2c0:c362:573e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd987c9d-3217-4ea4-a801-08d73314212a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:BYAPR18MB2982;
x-ms-traffictypediagnostic: BYAPR18MB2982:
x-microsoft-antispam-prvs: <BYAPR18MB298222231FC88CA24E0848EFA3BA0@BYAPR18MB2982.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(189003)(199004)(76116006)(6116002)(305945005)(91956017)(6246003)(14444005)(256004)(5640700003)(66476007)(2906002)(71200400001)(66446008)(316002)(64756008)(66556008)(66616009)(66946007)(36756003)(71190400001)(6486002)(81156014)(99936001)(54906003)(186003)(2501003)(81166006)(5660300002)(14454004)(76176011)(7736002)(4326008)(86362001)(25786009)(476003)(99286004)(486006)(8936002)(8676002)(2351001)(6436002)(53936002)(2616005)(478600001)(11346002)(102836004)(446003)(6506007)(6512007)(118296001)(6916009)(46003)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR18MB2982;H:BYAPR18MB3031.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: svz4JuQ8UutmngnbrWorKpi8l/6kQ7W6WbTTlvQoy5ZKUs6wCFCr62fpLRpTmFyWASNHiF1XyVyTU44PBNY3tNfrkzmSR+nOohyW4XdBMbbbq4XZNd7WocaWQ3sFsdi4CA7XI2ONp5xE6ODaliwmCfS/uSr6SfeLM6OfR7nK3cqX145hk01vwpyXjlNSFB+iENM/8jTV6zySK6YTpD/zE3Qm5frDQhuVLZQANyorNADkZlTRjgUUZE3DLnx1DIdDexN8IBd/VTBpR1cdBPRl40fpTJKdAtklTHgigNvnScOUTbQsPU0VVQwslfSa5qmKX4uFo8K3klRXByz+uoXaWb3xEYiUTDPyk980g/U2ZbDFisnjKaC/FKGDwJ8UtiXjDgisrF/5IGr+XVVtgWyvBTR1aTMssoFxBFQxW4kWfYQ=
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="=-EwPfmiN7bWS8BSIOSxVD"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fd987c9d-3217-4ea4-a801-08d73314212a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 21:49:44.2691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4O0LIKywRn8cPC0ETKM6UFb2rlGUbmA8aduht5EwuXEcFKXftN+Mu9HWKHGzusDU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2982
X-OriginatorOrg: suse.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-EwPfmiN7bWS8BSIOSxVD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I was playing with the new objects, etc, and found if the user
specifies -sgx-epc, and a memory device, but does not specify -cpu
host, +sgx, the vm runs without any warnings, while obviously not doing
anything to the memory. Perhaps some warnings if not everything which
is required is provided?

On Tue, 2019-08-06 at 11:56 -0700, Sean Christopherson wrote:
> Because SGX EPC is enumerated through CPUID, EPC "devices" need to be
> realized prior to realizing the vCPUs themselves, i.e. long before
> generic devices are parsed and realized.  From a virtualization
> perspective, the CPUID aspect also means that EPC sections cannot be
> hotplugged without paravirtualizing the guest kernel (hardware does
> not support hotplugging as EPC sections must be locked down during
> pre-boot to provide EPC's security properties).
>=20
> So even though EPC sections could be realized through the generic
> -devices command, they need to be created much earlier for them to
> actually be usable by the guest.  Place all EPC sections in a
> contiguous block, somewhat arbitrarily starting after RAM above 4g.
> Ensuring EPC is in a contiguous region simplifies calculations, e.g.
> device memory base, PCI hole, etc..., allows dynamic calculation of
> the
> total EPC size, e.g. exposing EPC to guests does not require -maxmem,
> and last but not least allows all of EPC to be enumerated in a single
> ACPI entry, which is expected by some kernels, e.g. Windows 7 and 8.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  hw/i386/sgx-epc.c         | 107
> +++++++++++++++++++++++++++++++++++++-
>  include/hw/i386/pc.h      |   3 ++
>  include/hw/i386/sgx-epc.h |  18 +++++++
>  qemu-options.hx           |  12 +++++
>  vl.c                      |   9 ++++
>  5 files changed, 148 insertions(+), 1 deletion(-)
>=20
> diff --git a/hw/i386/sgx-epc.c b/hw/i386/sgx-epc.c
> index 73221ba86b..09aba1f8ea 100644
> --- a/hw/i386/sgx-epc.c
> +++ b/hw/i386/sgx-epc.c
> @@ -53,6 +53,8 @@ static void sgx_epc_init(Object *obj)
>  static void sgx_epc_realize(DeviceState *dev, Error **errp)
>  {
>      PCMachineState *pcms =3D PC_MACHINE(qdev_get_machine());
> +    MemoryDeviceState *md =3D MEMORY_DEVICE(dev);
> +    SGXEPCState *sgx_epc =3D pcms->sgx_epc;
>      SGXEPCDevice *epc =3D SGX_EPC(dev);
> =20
>      if (pcms->boot_cpus !=3D 0) {
> @@ -71,7 +73,18 @@ static void sgx_epc_realize(DeviceState *dev,
> Error **errp)
>          return;
>      }
> =20
> -    error_setg(errp, "'" TYPE_SGX_EPC "' not supported");
> +    epc->addr =3D sgx_epc->base + sgx_epc->size;
> +
> +    memory_region_add_subregion(&sgx_epc->mr, epc->addr - sgx_epc-
> >base,
> +                                host_memory_backend_get_memory(epc-
> >hostmem));
> +
> +    host_memory_backend_set_mapped(epc->hostmem, true);
> +
> +    sgx_epc->sections =3D g_renew(SGXEPCDevice *, sgx_epc->sections,
> +                                sgx_epc->nr_sections + 1);
> +    sgx_epc->sections[sgx_epc->nr_sections++] =3D epc;
> +
> +    sgx_epc->size +=3D memory_device_get_region_size(md, errp);
>  }
> =20
>  static void sgx_epc_unrealize(DeviceState *dev, Error **errp)
> @@ -167,3 +180,95 @@ static void sgx_epc_register_types(void)
>  }
> =20
>  type_init(sgx_epc_register_types)
> +
> +
> +static int sgx_epc_set_property(void *opaque, const char *name,
> +                                const char *value, Error **errp)
> +{
> +    Object *obj =3D opaque;
> +    Error *err =3D NULL;
> +
> +    object_property_parse(obj, value, name, &err);
> +    if (err !=3D NULL) {
> +        error_propagate(errp, err);
> +        return -1;
> +    }
> +    return 0;
> +}
> +
> +static int sgx_epc_init_func(void *opaque, QemuOpts *opts, Error
> **errp)
> +{
> +    Error *err =3D NULL;
> +    Object *obj;
> +
> +    obj =3D object_new("sgx-epc");
> +
> +    qdev_set_id(DEVICE(obj), qemu_opts_id(opts));
> +
> +    if (qemu_opt_foreach(opts, sgx_epc_set_property, obj, &err)) {
> +        goto out;
> +    }
> +
> +    object_property_set_bool(obj, true, "realized", &err);
> +
> +out:
> +    if (err !=3D NULL) {
> +        error_propagate(errp, err);
> +    }
> +    object_unref(obj);
> +    return err !=3D NULL ? -1 : 0;
> +}
> +
> +void pc_machine_init_sgx_epc(PCMachineState *pcms)
> +{
> +    SGXEPCState *sgx_epc;
> +
> +    if (!sgx_epc_enabled) {
> +        return;
> +    }
> +
> +    sgx_epc =3D g_malloc0(sizeof(*sgx_epc));
> +    pcms->sgx_epc =3D sgx_epc;
> +
> +    sgx_epc->base =3D 0x100000000ULL + pcms->above_4g_mem_size;
> +
> +    memory_region_init(&sgx_epc->mr, OBJECT(pcms), "sgx-epc",
> UINT64_MAX);
> +    memory_region_add_subregion(get_system_memory(), sgx_epc->base,
> +                                &sgx_epc->mr);
> +
> +    qemu_opts_foreach(qemu_find_opts("sgx-epc"), sgx_epc_init_func,
> NULL,
> +                      &error_fatal);
> +
> +    if ((sgx_epc->base + sgx_epc->size) < sgx_epc->base) {
> +        error_report("Size of all 'sgx-epc' =3D0x%"PRIu64" causes EPC
> to wrap",
> +                     sgx_epc->size);
> +        exit(EXIT_FAILURE);
> +    }
> +
> +    memory_region_set_size(&sgx_epc->mr, sgx_epc->size);
> +}
> +
> +static QemuOptsList sgx_epc_opts =3D {
> +    .name =3D "sgx-epc",
> +    .implied_opt_name =3D "id",
> +    .head =3D QTAILQ_HEAD_INITIALIZER(sgx_epc_opts.head),
> +    .desc =3D {
> +        {
> +            .name =3D "id",
> +            .type =3D QEMU_OPT_STRING,
> +            .help =3D "SGX EPC section ID",
> +        },{
> +            .name =3D "memdev",
> +            .type =3D QEMU_OPT_STRING,
> +            .help =3D "memory object backend",
> +        },
> +        { /* end of list */ }
> +    },
> +};
> +
> +static void sgx_epc_register_opts(void)
> +{
> +    qemu_add_opts(&sgx_epc_opts);
> +}
> +
> +opts_init(sgx_epc_register_opts);
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index 859b64c51d..bb9071c3bd 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -8,6 +8,7 @@
>  #include "hw/block/flash.h"
>  #include "net/net.h"
>  #include "hw/i386/ioapic.h"
> +#include "hw/i386/sgx-epc.h"
> =20
>  #include "qemu/range.h"
>  #include "qemu/bitmap.h"
> @@ -69,6 +70,8 @@ struct PCMachineState {
>      /* Address space used by IOAPIC device. All IOAPIC interrupts
>       * will be translated to MSI messages in the address space. */
>      AddressSpace *ioapic_as;
> +
> +    SGXEPCState *sgx_epc;
>  };
> =20
>  #define PC_MACHINE_ACPI_DEVICE_PROP "acpi-device"
> diff --git a/include/hw/i386/sgx-epc.h b/include/hw/i386/sgx-epc.h
> index 5fd9ae2d0c..562c66148f 100644
> --- a/include/hw/i386/sgx-epc.h
> +++ b/include/hw/i386/sgx-epc.h
> @@ -41,4 +41,22 @@ typedef struct SGXEPCDevice {
>      HostMemoryBackend *hostmem;
>  } SGXEPCDevice;
> =20
> +/*
> + * @base: address in guest physical address space where EPC regions
> start
> + * @mr: address space container for memory devices
> + */
> +typedef struct SGXEPCState {
> +    uint64_t base;
> +    uint64_t size;
> +
> +    MemoryRegion mr;
> +
> +    struct SGXEPCDevice **sections;
> +    int nr_sections;
> +} SGXEPCState;
> +
> +extern int sgx_epc_enabled;
> +
> +void pc_machine_init_sgx_epc(PCMachineState *pcms);
> +
>  #endif
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 9621e934c0..8e83dbddbd 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -103,6 +103,9 @@ NOTE: this parameter is deprecated. Please use
> @option{-global}
>  @option{migration.send-configuration}=3D@var{on|off} instead.
>  @item memory-encryption=3D@var{}
>  Memory encryption object to use. The default is none.
> +@item epc=3Dsize
> +Defines the maximum size of the guest's SGX EPC, required for
> running
> +SGX enclaves in the guest.  The default is 0.
>  @end table
>  ETEXI
> =20
> @@ -394,6 +397,15 @@ STEXI
>  Preallocate memory when using -mem-path.
>  ETEXI
> =20
> +DEF("sgx-epc", HAS_ARG, QEMU_OPTION_sgx_epc,
> +    "-sgx-epc memdev=3Dmemid[,id=3Depcid]\n",
> +    QEMU_ARCH_I386)
> +STEXI
> +@item -sgx-epc memdev=3D@var{memid}[,id=3D@var{epcid}]
> +@findex -sgx-epc
> +Define an SGX EPC section.
> +ETEXI
> +
>  DEF("k", HAS_ARG, QEMU_OPTION_k,
>      "-k language     use keyboard layout (for example 'fr' for
> French)\n",
>      QEMU_ARCH_ALL)
> diff --git a/vl.c b/vl.c
> index b426b32134..8d3621ec4d 100644
> --- a/vl.c
> +++ b/vl.c
> @@ -141,6 +141,7 @@ const char* keyboard_layout =3D NULL;
>  ram_addr_t ram_size;
>  const char *mem_path =3D NULL;
>  int mem_prealloc =3D 0; /* force preallocation of physical target
> memory */
> +int sgx_epc_enabled;
>  bool enable_mlock =3D false;
>  bool enable_cpu_pm =3D false;
>  int nb_nics;
> @@ -3193,6 +3194,14 @@ int main(int argc, char **argv, char **envp)
>              case QEMU_OPTION_mem_prealloc:
>                  mem_prealloc =3D 1;
>                  break;
> +            case QEMU_OPTION_sgx_epc:
> +                opts =3D qemu_opts_parse_noisily(qemu_find_opts("sgx-
> epc"),
> +                                               optarg, false);
> +                if (!opts) {
> +                    exit(1);
> +                }
> +                sgx_epc_enabled =3D 1;
> +                break;
>              case QEMU_OPTION_d:
>                  log_mask =3D optarg;
>                  break;
--=20
Larry Dewey
Software Engineer
SUSE
1800 S. Novell Pl
Provo, UT 84606
(P)+1 801.861.7605
ldewey@suse.com

--=-EwPfmiN7bWS8BSIOSxVD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEB94YHaNARCPQPkE2xmOSSGc8XjsFAl1y1GwACgkQxmOSSGc8
Xjvx5g/+Pqp7glIB+mm0PmTEBeLsM1R4l1uJaBtpeLKxomfV42Gr4MSyqR0BDJH8
AQfo/E/SZ3PYfb58PjnwW48ihE6e42OuzdQkvzdTJCEfkCruntpJL1ADceK3dYlI
kA43g2/japdDOvJA4/U0i9JPnFMFU3XnNzS2fBoWP51/rYWiOA1Pm3LKe4tU9zAJ
cQ44WGJ04wjwe5bNp3XDjRC+IWGms1PJoIKEYD6kgtwNDNAVCkCrH8B+n5oxgBlv
qweRSkAYZXsDork4/mqGE7IVR0G9dClv4hua8zW7myOvb4zD/DI9I4yC2lBo/c4f
5CC7Mx0+FDiD2BZxgEloIsSBAOJYExGUm6v4noxguFGF90vC+eVJAqW9j0qMYPKr
X46sSxOMKvz0nwpmTbRbgBo1S9+kIdKgu3mm4CwODUHXikyBag6Htb5HRT2bP0yn
hyGD5YNvBiCNoPYztXhNLjbadL0KNhqIpxswMDrZ0O2rer9/Qu8SnXEkd7ZeEI39
fFaQn7v2L6tNa7boNIIiwyPQxb9GhGrkEYLI72GsNdn1+EEo69KeeBAvsdC5XlzQ
jQQpqs3cQgWYc5UJTatPsjWkhNVAAhO/kUcV9GZPCOI+6MfqSQX5DWH+ef7hZlUq
xoij99Pi8blslpv6WqmmDOwbSSXsae5uIszXIhizw2fvAQp5qMc=
=uLS5
-----END PGP SIGNATURE-----

--=-EwPfmiN7bWS8BSIOSxVD--
