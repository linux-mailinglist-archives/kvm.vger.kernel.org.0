Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215BE525F6A
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 12:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355585AbiEMJ6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiEMJ6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:58:03 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0C46C0FE
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 02:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652435879; x=1683971879;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C1mRHvMc/ICPww18qonV4fkhgmjMoRuEPNPA7mLUrMs=;
  b=DpXqAgaCeznu2Mm/ZTTt3N8RaAmgL2mpmdbDosAxAT2/fm7S5eBY8Gas
   WwZmCWr6lTwyWu0hZARnLXVk31n+F6MO0HaOzT3EN07E56x9qKyMyAump
   0m7Ai04CL0xkK2PkwD1M75CsGclqmWhqx4f1tzXuFYyAV7z/Nt3XJDB5j
   N2mRaAXqW26COJGiluL+j+zDuwyB63z8f3YZVOZRy5Xi3SECSPZlDY3Zz
   GpvW6IS5cBeuVfVJNJwqLL5M1wiP7eiOisZAbCQrIw5+TlvP5DGe9gXry
   BfM6ZpHdG6T427f93O1loa8GRfIM0VOHKpTrc4/140i26AGuu3UwJUJxv
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="252314041"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="252314041"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 02:57:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="896173656"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 13 May 2022 02:57:59 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 13 May 2022 02:57:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 13 May 2022 02:57:58 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 13 May 2022 02:57:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KehgwaRDef+3SofJHCA04La9+6naeOZFqvSoACEs+Jl7qbyryL6A3HTN31g0/m3N1axaaQNMO8zRURAEvxie4Vr1BdvT8HsXRapDKwVrVyssCXxGkr/RVJldlkFiiBjtOaP8fdK0v/LNyqe85uEMUdgoIgaTdR4vMZ2+llY+c3dCi1lxulEDZPnBiU+ziTD4XIM0uEmskqeabhhZ6HopImwdCrpUtHYeGHSzafos2+/+U2J1iTZN9GFyfh5BySPFhGg9wD4SMZXNB75wptN5PwyWpG/FqrgenN6mEEoPIyIvjKY6qd/L4syLLW8ub84x/Hy2KyLdKbDxq6MpRLj8Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iyvkwMe8RGhmbRJfku51drOziK+oyOBAREoN7cbU3sQ=;
 b=VTUHTAE5q2EdLSNmybuLEXDZaiA8k0LYxZ9BxuQgnqGgewF/jdyIGt/qy9imthNy0W97ifSqOwCkWfTnJxbBdtiruw/ohawViLvjtSnPiFEbuul+AyLG94upuLq0X+Tgt48nin2XWE5tmmfoofGYrnjmvlGTNpfYODgNqwZwKvfNeY9JF98tNsc6xqgDGrV32LtWOO+ZUF4Qv6ysp8LAKLAh16RumWA5SQHRoZef1uGlECoqnMc1wMkdfABa8sel4q8378Lxv+YjR5c/bI4iKIgXVz7y10k/gWICZjU2fIbeMsXiyReBP2fy+yRvM0m0+2HG3OcxDMMKhqGuwDfsVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4544.namprd11.prod.outlook.com (2603:10b6:806:92::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Fri, 13 May
 2022 09:57:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5250.013; Fri, 13 May 2022
 09:57:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: [PATCH 5/6] vfio: Simplify the life cycle of the group FD
Thread-Topic: [PATCH 5/6] vfio: Simplify the life cycle of the group FD
Thread-Index: AQHYYN/e2w3LHkQd4UiMp+by5fQqRq0cndTA
Date:   Fri, 13 May 2022 09:57:55 +0000
Message-ID: <BN9PR11MB5276768FE3C91DDA80541C9E8CCA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
 <5-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <5-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27df528d-b7a4-4a16-96bb-08da34c70d3b
x-ms-traffictypediagnostic: SA0PR11MB4544:EE_
x-microsoft-antispam-prvs: <SA0PR11MB45441D54D008234BDB2765038CCA9@SA0PR11MB4544.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FddISIjf9PYXMbq34kLHI3Kz6qtvxoTzS1IK9vUfpfh752Ha0VOpGK1iYe27UqcS9DlHgJQDPAEBxrXulpX96WWkOKo8uzltiQADfgqfHHtGjD0Wu+AzINOA/D+2vlNac2zgoDPG6u8vR/3x5/vK0+hniWW3mz/3oMcLrhvKeWe+Ggppb3MDuEQVcURJDM4PsHO5TRuPf0xvvoBJOK4ReAux/Ny51UFFO2geVvU2aVcZ9vnFuo0TuuIVTUyO3krhlC6ls01mIHjv5XFpqijnWcQmLtip5I9+0CzCVTgtdpaXL5W9NZXRdhrpkm0UyV6EwQS/cmzAOxvQc8ytL3d5am8zT1Mx08NyI1jRY1+FveAD47g2dzZ9W5Qpo5Rcx4st9IoPhCVch1SyLvXi4RO9nPHrdLeLFzy4xNJlk39U3VNHMdj7yGspHzWYLHTFDoML0JgByb/EI4HOWjNuxWl3+MJucBkEoc3QRTGe0RsYCWOYTCLwxwtw9RJu85WnBAaGaYBU3WV12/qo2Iu9eGt262RO+8vPBdv2Yh4OIQ5Tqwr+534rtSpVfWD+dJtVCSK6Cy8m3bharfMgtYrEuVMmn22a+Avi8SzbyiDGLxkEptefWNkKrRyNFNmqyurax/bJ3xYeSVkYOOWK2Dna7hDcTuz0lunrXs0W/nuTtB3OGuWXvgnF/BrlA/xYmqTjXHwnP5hjUXIpb2nbwiLLntV9wA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(71200400001)(55016003)(86362001)(33656002)(2906002)(54906003)(110136005)(508600001)(83380400001)(66946007)(66476007)(38070700005)(38100700002)(76116006)(82960400001)(52536014)(66556008)(316002)(8936002)(6506007)(66446008)(64756008)(4326008)(8676002)(9686003)(26005)(7696005)(122000001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JcC12KFneSKPSlnrOI+drdrjBdQbh9KanYX7nNhhyDBqyVzhmPrsRjJ9rxhd?=
 =?us-ascii?Q?cBGPapXmLOcVnyhESiNeMml72Ed6hM4dKZrVPakjuEBP0BUASKuK5CkDhXKu?=
 =?us-ascii?Q?wxMjblMhRz5PmjKbHb52ZJAuUv/clKZno6Nqy7RjTYn87t2RtA4WOfyOuFbB?=
 =?us-ascii?Q?j4e15+VK10+lMMzJKgR5wBEyWRbo7VcuvA9k3qQU0yYB/Ko2pg5FFGB27spA?=
 =?us-ascii?Q?T7yzN3o//Ilhz2XpYPgJM7YM0Tbv0m+ZY1bdIAxL526uZKokjZL0Ag5P4FqX?=
 =?us-ascii?Q?ndSzhgTCIt4mB/GzKSH41mrSZ6h2s1zCnQ5D0yPf2b6PSaGlKH8GkoRJtdfT?=
 =?us-ascii?Q?naIGvx64KtRaYphCzmfn40+pTgVKnrW76CTQ5cE8SjfYK66JTCy4GHt+XAr7?=
 =?us-ascii?Q?9TVHLlg3ZOdhS799KCpJd+FDfSvE4mrdcbZ3HyTE2kZuHgy/0o5HMErtPKI5?=
 =?us-ascii?Q?Pucxj6Y01ExANhCBthl0dz86pZkZueN/FG93dNP+jwQpIXzPV43g8LF9ZBlL?=
 =?us-ascii?Q?XoGm9dsWPXSMpkWJZraOBCnuLNuyduA2Lu/l/DYLfwlEao88vRJvktzVAegP?=
 =?us-ascii?Q?Gzf+r05uiPhX7ZMom9zDFeuXSKuXOjQDJgP8z3vgbXo9pTlEv+WKO+extlRY?=
 =?us-ascii?Q?pwK0WN3kA4X0h1iavB84XalSQO6FQ5eue/0M7D6IGES5OKjLGTAVDaMXhnhk?=
 =?us-ascii?Q?xo1apgBVxnnELwMc3ehNrmf/z+SMkXLdtegVU/Wh247PpgZUeE6C48IBbkaO?=
 =?us-ascii?Q?SL98CbQH0VbbkZEq9HuBODnaLAORu3PdeEbT3jpqKCtQXT1FeePwcIgBD8uZ?=
 =?us-ascii?Q?T9C9bes/IWv1zQM9Gkb+LvyCoVtBoHFYPTf7rmrTkmMa54/E3sARU03K+f/n?=
 =?us-ascii?Q?9VPWwCg/46THRlKNtX+6MF+JbGos8Rv05Q8Noll92ZDz0pel5SoeTb3wguRU?=
 =?us-ascii?Q?y7px+/8o1oyEBmIuTExqej6vmLhPaAScW3faDD58vtYdT11IusrIxHCcfNZp?=
 =?us-ascii?Q?kPhEKLg5Mfgrpy8HmegrFFUKwtMrn4rdtDtc4+qQQp8uptbSOtyqxuuH+oKZ?=
 =?us-ascii?Q?BOP2IUz7QyqFRbO0kLzrzk48sWLYTlq4tGjCZlqPTMBkNzJNnG22MesdMmT7?=
 =?us-ascii?Q?KKG4RsHk2XDHOr0VmBAEpO4WwZurBnjEj753KpwBbfHa9TlsAvcJCHkOVRPz?=
 =?us-ascii?Q?bofUJp4kbMsvQJJbZqdUKkoqHPO3oTEN6LTDKtpg7wkKupAdFWqWHeNs8jKX?=
 =?us-ascii?Q?ZAV8RplPpBSF6qZUZ8jiAe8UATYs40uoFQUzs18XXaMT0HSkY8uJ/4sjp4gN?=
 =?us-ascii?Q?K8wtr8nVKnFJj2GvNvofiZ5qg3VHyWDqsO6ZTFodz/HqydcqmEen1A29ExoA?=
 =?us-ascii?Q?gAgkCjL5F4vvrDc7AaHWETkIK9i+C1v+huhIa5crxNFqBEkc1CYx/yXaA4Ax?=
 =?us-ascii?Q?ovyqO6GXvsKRvrLJaCxrZ0ZakJnqDAVl0nfJSYjnMMKf/keD/0P2+r+w6B4E?=
 =?us-ascii?Q?GOJ/EcK0Buvf+L97+0npnSZr4KvtHGfl6GKcIP92smZxWbesJQ9UUjMvrngO?=
 =?us-ascii?Q?7yUPm99lBuR6i6mpYILemEfW4+PIfzcWITLoDVEdZo4sraHj2S4vrsqSd8Ht?=
 =?us-ascii?Q?/rEGtXqXbGeKY+eU+RMmhxN8K7gN4f1AZfd27EBnTHOLQZx0tGo951SzsyUl?=
 =?us-ascii?Q?XbKjkiXT/z1NmCs1MbQK0eYWG/2hinPoGIK07zStmj9uPwQDIU+7/Vak06JQ?=
 =?us-ascii?Q?f9V6ZllK4g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27df528d-b7a4-4a16-96bb-08da34c70d3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 09:57:55.1335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jGmkhcyfJCC7oX58MeR4U232Cu6MYx9ILXTW9KFDksSKVN6VQEzQ46yvwoMMOXMrY355Sx/A+p0huQLtmgsikA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4544
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, May 6, 2022 8:25 AM
>=20
> Once userspace opens a group FD it is prevented from opening another
> instance of that same group FD until all the prior group FDs and users of
> the container are done.
>=20
> The first is done trivially by checking the group->owned during group FD

s/owned/opened/

> open.
>=20
> However, things get a little weird if userspace creates a device FD and
> then closes the group FD. The group FD still cannot be re-opened, but thi=
s
> time it is because the group->container is still set and container_users
> is elevated by the device FD.
>=20
> Due to this mismatched lifecycle we have the
> vfio_group_try_dissolve_container() which tries to auto-free a container
> after the group FD is closed but the device FD remains open.
>=20
> Instead have the device FD hold onto a reference to the single group
> FD. This directly prevents vfio_group_fops_release() from being called
> when any device FD exists and makes the lifecycle model more
> understandable.
>=20
> vfio_group_try_dissolve_container() is removed as the only place a
> container is auto-deleted is during vfio_group_fops_release(). At this
> point the container_users is either 1 or 0 since all device FDs must be
> closed.
>=20
> Change group->owner to group->singleton_filep which points to the single

s/owner/opened/

> struct file * that is open for the group. If the group->singleton_filep i=
s
> NULL then group->container =3D=3D NULL.
>=20
> If all device FDs have closed then the group's notifier list must be
> empty.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

With the name change suggested by Alex:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c | 49 +++++++++++++++++++--------------------------
>  1 file changed, 21 insertions(+), 28 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 63f7fa872eae60..94ab415190011d 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -73,12 +73,12 @@ struct vfio_group {
>  	struct mutex			device_lock;
>  	struct list_head		vfio_next;
>  	struct list_head		container_next;
> -	bool				opened;
>  	wait_queue_head_t		container_q;
>  	enum vfio_group_type		type;
>  	unsigned int			dev_counter;
>  	struct rw_semaphore		group_rwsem;
>  	struct kvm			*kvm;
> +	struct file			*singleton_file;
>  	struct blocking_notifier_head	notifier;
>  };
>=20
> @@ -987,20 +987,6 @@ static int vfio_group_unset_container(struct
> vfio_group *group)
>  	return 0;
>  }
>=20
> -/*
> - * When removing container users, anything that removes the last user
> - * implicitly removes the group from the container.  That is, if the
> - * group file descriptor is closed, as well as any device file descripto=
rs,
> - * the group is free.
> - */
> -static void vfio_group_try_dissolve_container(struct vfio_group *group)
> -{
> -	down_write(&group->group_rwsem);
> -	if (0 =3D=3D atomic_dec_if_positive(&group->container_users))
> -		__vfio_group_unset_container(group);
> -	up_write(&group->group_rwsem);
> -}
> -
>  static int vfio_group_set_container(struct vfio_group *group, int
> container_fd)
>  {
>  	struct fd f;
> @@ -1093,10 +1079,19 @@ static int vfio_device_assign_container(struct
> vfio_device *device)
>  			 current->comm, task_pid_nr(current));
>  	}
>=20
> +	get_file(group->singleton_file);
>  	atomic_inc(&group->container_users);
>  	return 0;
>  }
>=20
> +static void vfio_device_unassign_container(struct vfio_device *device)
> +{
> +	down_write(&device->group->group_rwsem);
> +	atomic_dec(&device->group->container_users);
> +	fput(device->group->singleton_file);
> +	up_write(&device->group->group_rwsem);
> +}
> +
>  static struct file *vfio_device_open(struct vfio_device *device)
>  {
>  	struct file *filep;
> @@ -1155,7 +1150,7 @@ static struct file *vfio_device_open(struct
> vfio_device *device)
>  	mutex_unlock(&device->dev_set->lock);
>  	module_put(device->dev->driver->owner);
>  err_unassign_container:
> -	vfio_group_try_dissolve_container(device->group);
> +	vfio_device_unassign_container(device);
>  	return ERR_PTR(ret);
>  }
>=20
> @@ -1286,18 +1281,12 @@ static int vfio_group_fops_open(struct inode
> *inode, struct file *filep)
>=20
>  	/*
>  	 * Do we need multiple instances of the group open?  Seems not.
> -	 * Is something still in use from a previous open?
>  	 */
> -	if (group->opened || group->container) {
> +	if (group->singleton_file) {
>  		ret =3D -EBUSY;
>  		goto err_put;
>  	}
> -	group->opened =3D true;
> -
> -	/* Warn if previous user didn't cleanup and re-init to drop them */
> -	if (WARN_ON(group->notifier.head))
> -		BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
> -
> +	group->singleton_file =3D filep;
>  	filep->private_data =3D group;
>=20
>  	up_write(&group->group_rwsem);
> @@ -1315,10 +1304,14 @@ static int vfio_group_fops_release(struct inode
> *inode, struct file *filep)
>=20
>  	filep->private_data =3D NULL;
>=20
> -	vfio_group_try_dissolve_container(group);
> -
>  	down_write(&group->group_rwsem);
> -	group->opened =3D false;
> +	/* All device FDs must be released before the group fd releases. */
> +	WARN_ON(group->notifier.head);
> +	if (group->container) {
> +		WARN_ON(atomic_read(&group->container_users) !=3D 1);
> +		__vfio_group_unset_container(group);
> +	}
> +	group->singleton_file =3D NULL;
>  	up_write(&group->group_rwsem);
>=20
>  	vfio_group_put(group);
> @@ -1350,7 +1343,7 @@ static int vfio_device_fops_release(struct inode
> *inode, struct file *filep)
>=20
>  	module_put(device->dev->driver->owner);
>=20
> -	vfio_group_try_dissolve_container(device->group);
> +	vfio_device_unassign_container(device);
>=20
>  	vfio_device_put(device);
>=20
> --
> 2.36.0

