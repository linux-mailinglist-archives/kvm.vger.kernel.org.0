Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B589699057
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 10:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjBPJrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 04:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBPJq7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 04:46:59 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACCA185;
        Thu, 16 Feb 2023 01:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676540818; x=1708076818;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ywJOSBRndfe/0JlLQTQNNgS37t90wn/imF0o8SN6Igk=;
  b=FBQ6S8pq58GYTnPrHLfs0mQlZWAJgBYpxwL1fpo5WO2EVuhi4Gu1va93
   Pkq6yVzW6j9RP0DYPisqT/YRNbUQO6KEwkfKmLoAzYYh7q2Ky+gm3nwYa
   0eZLFleb471e2o7FrDSngYg1365pEpZANnzDvwSDhOixlpN9C0DgkUhbx
   2AUM614fCCKKW6Xu7sKHaUw8hM37xl40hoL0AKlc2WglUSN370ECeQ8L2
   mhRulUrjlv7jsF9X0zGS8p+rJLx81mwBO7EdG55P0drhmH4hG5I5LSIOV
   yDFxDY6398utqtpWPhJ33ACZjX9JaTwlK76W1ceRQlX4o6nkB6S6RuVAq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="359105356"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="359105356"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 01:46:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="733813534"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="733813534"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 16 Feb 2023 01:46:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 01:46:56 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 01:46:56 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 01:46:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFHOrLDFEdvnSSionffmkDVYTY2bhQNItrmhrW9XxLyJhok2s6KsakovmmW/eZ0NaADvnExENP3J5gJ07/8uZXDa2ZK5r6OcldTX53W1/M3XlX6jvxo5xaizYMkS4b2ue3tovZ/GtG8GLYy4/02Bv3jtNY389h1jY2gc9sxRfeBj8euIC/cJu/jiUnmGQEcWHdKR1tM1vtaWcvAc2v+AZ0ur36MCBJszoTSy4w7nuy7vxkosCN0w0rSNhVYJ1Uy8FAqR4su5lD1HrYeZS/rZaKKTdsLKeo+eVaK2MkMgzsZXf0VAh6m4gEN13Jh7emVRpCEIodW7sfqiQ3gdTw27Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Frbl0k84L9tzgfK8FGTbmm0uYN9KLO/G87IofdPSaPA=;
 b=i5bZvZ/tlj9aE927CJOfwyjlRw2BGuAIOL08AmuwdpFFgSq638IkBZI0c6y4S5gIZqjCrBQc+oksOrk/6+mwrNfndNLH0+257tfziUuhB9cawgGfmm8sA7dnSYqwO5b2H+y1OMXUsmgxisdF+mZbP2sUl9E3xU4SFMwoMdiuAZhC3hLoj26/AwW4Aj+62BRMSScu8ZyVhxilY98b+OMPuLSdUqf++XhZ8+9svg3HxooXbXHdLThAq+gZUAuqrWIyvrHThBtyty5kXbvYzpDGTdEI4kytFBl7FW+lSwRupcZkIqT9LdzpZ8O9fH6vuNTnzk5aEUusyeqMfZPurHgDUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6609.namprd11.prod.outlook.com (2603:10b6:510:1cc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Thu, 16 Feb
 2023 09:46:54 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef%7]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 09:46:54 +0000
Date:   Thu, 16 Feb 2023 17:23:06 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH v3 14/15] vfio: Add ioctls for device cdev using iommufd
Message-ID: <Y+31+puocZcGFnSQ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-15-yi.l.liu@intel.com>
 <Y+3oObuMG/v3+x0N@yzhao56-desk.sh.intel.com>
 <SN7PR11MB754074DEC60C9852D42EA4A6C3A09@SN7PR11MB7540.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <SN7PR11MB754074DEC60C9852D42EA4A6C3A09@SN7PR11MB7540.namprd11.prod.outlook.com>
X-ClientProxiedBy: KL1PR01CA0116.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::32) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6609:EE_
X-MS-Office365-Filtering-Correlation-Id: ee958986-f62a-45f7-d86e-08db1002bc17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l2ssdTn2LUXR8WMXgyNLQx8P4hyuhV2aTsE4ENcvWZX/mtjDWRQJwLdk+XIJYIAyS9j439PxCtnW9k4KE/kBkgB7s5Ti3+Lf03jDbXDlrlTVzsTHDUqFxk9w5nnaWzyDDdzWe4wqVstPSzDJN7NIBHOD+BWvKqU37PvpIcp9h6McOV4i35bXm8ZfrqkTZFu6M0WIsFHuT8Yyv/3x7HA7wU9YY6eY56a0wQ+gjrdupm+76P0oNSN5ywhHhCdauyybqzmhLwldxNc5psVcOIXANmTkIntdYvHurBx8CixKNDvsRscKXTADkuSeXQ+jmDopOVQ6YcZuQjeGFk8cbhBJoTFp/Few0EYruVRLskWg5K5LQEqH3njiOiveM1WIVjy7TqoXq2/mXZSuHnO5k82kcjSRjP4Kl9I4R5r6ITOYPu9Zs/cfvvQ5rabwiaG7wX6+Z1AlCgRm0RDRBzw1h/fr+Qa4vfkGjWO3r9+aTzE6zENrPyKTZkJtvVEWtu4h2g7lkFA2sTvUSFRBE26N8AilyUpA2J4MV0zF5iXvkx4JNpJgTeJaoy5Xxvy/DhVwyVHChaqz7UhxAooRgEd6hGQGSpbcro6icOFMzj7aXYG3ZQK6xzk4AWz/EFOaVeuIS16/G720H48xZj7AVTCbSFs3DA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199018)(2906002)(3450700001)(41300700001)(8936002)(7416002)(5660300002)(6862004)(66946007)(4326008)(66556008)(66476007)(8676002)(316002)(478600001)(54906003)(6506007)(6486002)(6666004)(6512007)(26005)(86362001)(186003)(83380400001)(38100700002)(82960400001)(6636002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YlHXptfZxtpOc3xYQbDYZpfA7ym04cINfrj8R9kFuJhkk86FRmzPsebr+oIg?=
 =?us-ascii?Q?L3iLhgBLVk1lq0ebqXOCYCzKDDYswaS4UUbbEBYsxF0Im1GO9XiuRrbb3KuR?=
 =?us-ascii?Q?4ryB0bTeovve1hnGDLzXbX9UnZAEo3AtWDqlr8LJHX8AhBRs3u37P+ccWj7w?=
 =?us-ascii?Q?jtHgmCQBpDOoB32ueSUDI6oV5McCoWRF2To7zJ/1MAkFFU04RhMoB8EMGxf9?=
 =?us-ascii?Q?i9h1eYrvAzM3VzadkyUtCvHyb9+S0VNxVEBx6XYxc91dyAhwH7ktjNB/VLzC?=
 =?us-ascii?Q?vsjwMRUWILR0E89t6r4nuMYf6mH3f8LpTNdQO9MAEKP2vuPZXng8pMIhCnc8?=
 =?us-ascii?Q?tguP15P/Gs7M6O0eLaNHY0TJWP4ccWewipX3mjvOVKKRakL9AODyVYUIFCJS?=
 =?us-ascii?Q?wCmcCWnZbunskiJp2+ccrH7em1ZKdAuY5DHEafQnzFEhiBBaCoGQckALPyz2?=
 =?us-ascii?Q?o1MNgBdMSFTzbbp6b8xIDtX8HAhLPhq2d4Srazmu1hAJn1rY/RV+LqpXvUC5?=
 =?us-ascii?Q?wttE5IgskCQ5EJzmy5US2X+U3OlIFcGytCsCnBzEx29eX3NZ0FU7usfHBP5T?=
 =?us-ascii?Q?n59VMH248KbskNqmWGFjG8BUPWtiCcS0zR82rrwABLVoQElnXIDU+B6pQE8V?=
 =?us-ascii?Q?vMRxsU22OiCOPqNk527aHmSoxdWKP55OkI3MDaqDYG9phSSDL3ePFqYIAK88?=
 =?us-ascii?Q?GrPW0jbftHeo272IVtBq3YJgnfNVnFUGcrGgyLAee3AK1aek+RpnxP20qwmy?=
 =?us-ascii?Q?r53s7Cfyy2Rg9xo+Dae/vXPfSki4H8obuoy6ErpA1Xm0U3PeO7aF0fBUEEmY?=
 =?us-ascii?Q?oCh0+rhDXFZqSpFebVyoS+l9sQr9EEMnk/+4KCg3Iag1ZHwSpQSIXCx1eBnL?=
 =?us-ascii?Q?EcqxfY4VuaSoydf4siRRK1MVqyxSGN+O7Gjdne+Iuf/XnNCSgpvmBjMQZGoK?=
 =?us-ascii?Q?RIJ0or55k2hRUYboT1QWAiwYGIoTveMdClQ0QEbRe5x/g8jkp3nkW8iyJk3T?=
 =?us-ascii?Q?zIIiJVk/njsZ9JjP8NyYlAGNNKiYFQiF4gnefhvav4UWH3oB8DOI6INSUnyo?=
 =?us-ascii?Q?EHsYAg3JWTI7WLZU/PkyIuPJEBfJSqqEydhU8KU7ryxSUgCDu+ctYYcOXARC?=
 =?us-ascii?Q?abwP9yFQLRiVSPP3u3Bqdo2bj8Dhkj50siz2KjAh6CsznJW0DJ3FBu0e4Eh5?=
 =?us-ascii?Q?5t+pNI02w5DUfFUpXlDs571XZecQXjo4feju4PeN6MJPEoeSQiXbcj1irZBs?=
 =?us-ascii?Q?EppBjz0EgfeHECYoKgTkL9eursW82cZEbPNyQpeHLAa6Yedsz7s//n3dzMod?=
 =?us-ascii?Q?YBH6coQKItkxA2Qc6MYCXuM9Hbx94sHmrJoaSPVzVGQyU/bf2GJb04IObwT3?=
 =?us-ascii?Q?QUGDqKiXnw9tACyqhc/8dzLvi9gNgCLeHO+WzcoRTqzb9e42y+AJsnhKYq+o?=
 =?us-ascii?Q?WHv1qrzPHyxbF+YY9YTpk7hco1+7ROQZAg/jr3V1KTFbZKZcA9bl5L0Xl+LV?=
 =?us-ascii?Q?D0jvsSPfQ1gCrIPMY8b9QHXQEO5u81zaP1KE+4F2Kvtvb7J4EWNq/xdwxTWO?=
 =?us-ascii?Q?ialOO7WH0+zw4R0+mAYhJdzDJkcHY61oj3WcklmBVbuQyDnnrpSa4kBSOXEK?=
 =?us-ascii?Q?kQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ee958986-f62a-45f7-d86e-08db1002bc17
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 09:46:53.6902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8D9+tEx/C64oV4NF9P44CnLkt9P9KJ2xKBF2Cb+bxbwCqwBck1/M+s3qbHRkr2oAhePa8zqr4BGhJmKyhSZBqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6609
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 16, 2023 at 05:10:06PM +0800, Liu, Yi L wrote:
> > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > Sent: Thursday, February 16, 2023 4:24 PM
> > 
> > On Mon, Feb 13, 2023 at 07:13:47AM -0800, Yi Liu wrote:
> > ...
> > 
> > > +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> > > +				    unsigned long arg)
> > > +{
> > > +	struct vfio_device *device = df->device;
> > > +	struct vfio_device_bind_iommufd bind;
> > > +	struct iommufd_ctx *iommufd = NULL;
> > > +	struct fd f;
> > > +	unsigned long minsz;
> > > +	int ret;
> > > +
> > > +	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
> > > +
> > > +	if (copy_from_user(&bind, (void __user *)arg, minsz))
> > > +		return -EFAULT;
> > > +
> > > +	if (bind.argsz < minsz || bind.flags)
> > > +		return -EINVAL;
> > > +
> > > +	if (!device->ops->bind_iommufd)
> > > +		return -ENODEV;
> > > +
> > > +	ret = vfio_device_claim_group(device);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	mutex_lock(&device->dev_set->lock);
> > > +	/*
> > > +	 * If already been bound to an iommufd, or already set noiommu
> > > +	 * then fail it.
> > > +	 */
> > > +	if (df->iommufd || df->noiommu) {
> > > +		ret = -EINVAL;
> > > +		goto out_unlock;
> > > +	}
> > > +
> > > +	/* iommufd < 0 means noiommu mode */
> > > +	if (bind.iommufd < 0) {
> > > +		if (!capable(CAP_SYS_RAWIO)) {
> > > +			ret = -EPERM;
> > > +			goto out_unlock;
> > > +		}
> > > +		df->noiommu = true;
> > > +	} else {
> > > +		f = fdget(bind.iommufd);
> > Here, the iommufd file count + 1,
> > 
> > > +		if (!f.file) {
> > > +			ret = -EBADF;
> > > +			goto out_unlock;
> > > +		}
> > > +		iommufd = iommufd_ctx_from_file(f.file);
> > iommufd file count + 1, again
> > 
> > > +		if (IS_ERR(iommufd)) {
> > > +			ret = PTR_ERR(iommufd);
> > > +			goto out_put_file;
> > > +		}
> > > +	}
> > > +
> > > +	/*
> > > +	 * Before the device open, get the KVM pointer currently
> > > +	 * associated with the device file (if there is) and obtain a
> > > +	 * reference. This reference is held until device closed. Save
> > > +	 * the pointer in the device for use by drivers.
> > > +	 */
> > > +	vfio_device_get_kvm_safe(df);
> > > +
> > > +	df->iommufd = iommufd;
> > > +	ret = vfio_device_open(df, &bind.out_devid, NULL);
> > iommufd file count + 1 in iommufd_device_bind for first open.
> > 
> > > +	if (ret)
> > > +		goto out_put_kvm;
> > > +
> > > +	ret = copy_to_user((void __user *)arg +
> > > +			   offsetofend(struct vfio_device_bind_iommufd,
> > iommufd),
> > > +			   &bind.out_devid,
> > > +			   sizeof(bind.out_devid)) ? -EFAULT : 0;
> > > +	if (ret)
> > > +		goto out_close_device;
> > > +
> > > +	if (iommufd)
> > > +		fdput(f);
> > But, only one file count is put.
> 
> Good catch! Yes it is missed. And needs to call iommufd_ctx_put()
> in vfio_device_cdev_close() as well.
If I read correctly, iommufd_device_bind() in the first open will
get the reference through iommufd_ctx_get(ictx) and 
iommufd_device_destroy() in the last close will do the iommufd_ctx_put().

As vfio_device_ioctl_bind_iommufd() isn't paring with
vfio_device_cdev_close(), I think the fix below is simpler :) 

> > Need a paring iommufd_ctx_put() after a successful
> > iommufd_ctx_from_file()
> > above to avoid iommufd_fops_release() never being called.
> > 
> > e.g.
> > 
> > @@ -1222,11 +1226,13 @@ static long
> > vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> >                         ret = -EBADF;
> >                         goto out_unlock;
> >                 }
> >                 iommufd = iommufd_ctx_from_file(f.file);
> >                 if (IS_ERR(iommufd)) {
> >                         ret = PTR_ERR(iommufd);
> >                         goto out_put_file;
> >                 }
> > +               iommufd_ctx_put(iommufd);
> 
> Since iommufd is recorded in df, so needs to hold refcount till
> df->iommufd=NULL;
> 
> 
> >         }
> > 
> >         /* df->kvm is supposed to be set in vfio_device_file_set_kvm() */
> > 
> > > +	else if (df->noiommu)
> > > +		dev_warn(device->dev, "vfio-noiommu device used by user
> > "
> > > +			 "(%s:%d)\n", current->comm,
> > task_pid_nr(current));
> > > +	mutex_unlock(&device->dev_set->lock);
> > > +	return 0;
> > > +
> > > +out_close_device:
> > > +	vfio_device_close(df);
> > > +out_put_kvm:
> > > +	df->iommufd = NULL;
> > > +	df->noiommu = false;
> > > +	vfio_device_put_kvm(device);
> > > +out_put_file:
> > > +	if (iommufd)
> > > +		fdput(f);
> > > +out_unlock:
> > > +	mutex_unlock(&device->dev_set->lock);
> > > +	vfio_device_release_group(device);
> > > +	return ret;
> > > +}
> > > +
