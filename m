Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B93A510021
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 16:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351473AbiDZOPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 10:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241630AbiDZOPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 10:15:06 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E9B167DF
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 07:11:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SuDh+UNKRwtDQN+w1bF4qKOsDGvPd2vgsla6DwhaTMR/IcnRFUNXbou4fbuSPXwzcmRF9pnOACr3UfwMts9unDtm7OoLFYd/WCqF3V+Tx/k2N13WwK6vmcw54wI2wd87oKY4Hvh1Q2OzfYwl2IWTzMHZ5VHzL10qSR5j4dnDsrTqd2hqHJY0hctZ/sa5JZrqpxlm+liDa4rVgtnh1yTdqy6dmAdXymGJGWoBUPjTQbt5VllOCUgOnTeW3ubnJkHfcE94ZKBdpVpXuuOEgHQIqbkrEhLlGfs7d0t/s1ZsFRHhjxAvLsb2CanEzuJkL2Jk6rKqm7YCauIPTxQ7PQQlSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=duiwDB5kcWZlKHl0Dx+6RUy9Qrort2Q+wd7kod72u40=;
 b=LIwqNHhlZAgDtI+3my+ZNuI1It21pUGytI9m8nW8MFNfOv1Lf3Uoqz6CZUoh0N1pr1kbqBZgul8HPWdqwVzzEE7EskMsa+nzQG6WWhZ28f7/L7tOXpqZLAxNOmdncvLcON7lRkbgRAKj5EwsMH36s2vWYsvpUtIqVULubMzb2aGZTAJl312T34cMT3DYLcCPgnZHuevFcR2r8E8/pn4BAqlXGpGqEZiASnDL7b6lH2HWl+V+WcoiuJWRWr8cSvqwUWZG1SPIRj17Cvh15+cKWmizuEpPRZ6ciZEhmj49DWScrFMtyeHgAEvTGnF2wE1OuuIFbi/kevO+8dnWR7iZrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duiwDB5kcWZlKHl0Dx+6RUy9Qrort2Q+wd7kod72u40=;
 b=XAjlUmP41Q27bxZw7eoVEYO1CKLGFFw0vpQtKGU7qlZekRJba5ptAT8GWSrqDhYR4qcHwc8DXpIh3pCyJguiVD0dkFUEBV+DQ6HpcnDChs8A3b4yBGACxQ0QTum85xxXgSKsg7hS50SvUfjkpMZyoF5ojtcRndu9bnh/5hfbtu9xw6Ig73dZpwmd+JGOVU/k1+WOHAsyHX3RQYZ69a0M52d2VZUgLxhKpoAT/OiXhlc4EcXaELyR/HY4AZ/IRgK5L3lRgQx1b4iHwTPuqD4IFBlsgkEa/d9qQTe4jb4MJbTPe1bwVSYUs7uVapV2bAjzmjVuZ+Tz/nDhhn8g0Me9wg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DS7PR12MB5934.namprd12.prod.outlook.com (2603:10b6:8:7d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Tue, 26 Apr
 2022 14:11:57 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 14:11:57 +0000
Date:   Tue, 26 Apr 2022 11:11:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>
Subject: Re: [RFC 15/18] vfio/iommufd: Implement iommufd backend
Message-ID: <20220426141156.GO2125828@nvidia.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <20220414104710.28534-16-yi.l.liu@intel.com>
 <20220422145815.GK2120790@nvidia.com>
 <3576770b-e4c2-cf11-da0c-821c55ab9902@intel.com>
 <BN9PR11MB5276AD0B0DAA59A44ED705618CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220426134114.GM2125828@nvidia.com>
 <79de081d-31dc-41a4-d38f-1e28327b1152@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79de081d-31dc-41a4-d38f-1e28327b1152@intel.com>
X-ClientProxiedBy: MN2PR19CA0030.namprd19.prod.outlook.com
 (2603:10b6:208:178::43) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8e75f52-d299-4a47-a872-08da278eb93f
X-MS-TrafficTypeDiagnostic: DS7PR12MB5934:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB5934B777FEECE1AA25FD268FC2FB9@DS7PR12MB5934.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Ys6uiHO194WJoUPz4JkQYVtKRBQAppEvKGdpgVe4W+hC24ZzIZV0JnMXnYac5G/AiENdHV+mRxxrcjkaveVuMhfZueiy36VQCuFQpPX6kGzGB2MKgi68Km8OPqpqxDvIs+rUfIE9k3KAgcIsUVk3DgW8hErg6e1kHWXaAxnaUzaCJSwcMD+dnIH8UF32lfbT1B6MBpWXiBrkqsTKHi0BROpAFZfgAWcwsZJc0nZZMVepnkJmifgVQuL9SD/d+3Syp9js7XEqEMTmnqxdgCLXY6p2hzncxrn15OpLdpvybrjZU0qpMx5T8pjT6fnCwrqlebh0MfqbY7FUzoYte1S7mNKiYGEXq0PC54SC068wk8RxYi2S0YZrlqRHaS633bslzO3YxYDqcWxNts1WpF3hOjyZtbjIk0hkTxCBSA6QnPaVvUsQ+xl22Vp1XjLcunkvpfigfPoeO0b1f46o/9PT6jEAVushDin1sKTiD9mWmoWND6XtJmwQ55uCsSRg5iODalf86LdNixuKV4fkWj2f7C2ThbtNbF6Uc29338QbHVEQbZQYptL6NjEJW8GppIt+WjMrCYqMR+sFVB+oPEO+7Rp+XTW3CTSl14Vmq9nwpm/qSFQ0HtZ2smer0mTwoIw7CPCeK+n8nvL9nKunVNJvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(7416002)(8936002)(8676002)(66946007)(5660300002)(86362001)(6486002)(2906002)(508600001)(38100700002)(66556008)(66476007)(83380400001)(6916009)(316002)(186003)(2616005)(1076003)(54906003)(26005)(6506007)(6512007)(33656002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mb6q9vY1Pm1g8oKXCTCwXjWSdytcEfpJy2UmhoPDNkNFIIwu0gMcWon4fJF1?=
 =?us-ascii?Q?gKzdCh8CX+TKVrDc8a6DuWSfCYjHSiRHWpMB5LVdY6mC3iNB2j49js0+P2wu?=
 =?us-ascii?Q?cmd/OtC+OIE1DkeXwrU9qGVM53NQJ5DGG4o9n3ACr1rVdNKbTjo59dfZHn2n?=
 =?us-ascii?Q?T5HIZIhYGXA3mRphBgo2xnG//rAID/5qGHkoD7/ScPeR7U9qPB8W+jF27NlM?=
 =?us-ascii?Q?DLqZdO72RKrHFHTWPVUiHWaQmui2tgCB6+RtA5lg1sQZHskKzk7Oipnsaipn?=
 =?us-ascii?Q?uo3qLXDGWU9m+z3wPknPCK3Yn0cn3YEvQ0Y8yVCng68skWhBYr1xUVuKk6ql?=
 =?us-ascii?Q?MXwF7JE1fSaLTf++V9ecU7NeB5LGrJrPqpWXNMtNTM2makY+vmUtMp6xvJQr?=
 =?us-ascii?Q?sZ1eV2R0MgXimZVxXbOlOf/xisfpUNaLmjyMuNtUeEveY6TDjjzh+P00Aq2Y?=
 =?us-ascii?Q?ayOi+JnOHKcgJkDh1pzDaPPVoPzvAsSgzhQZxzZ+Vy826mfOYaiEpSxnKizO?=
 =?us-ascii?Q?w9/tUHYRF04EkSkhZszREeYAJFzVGLyQXTWDvQkXAeKONq4Q5WmpZEvg+qWd?=
 =?us-ascii?Q?61oM6D1+7/lLTbp2z6rH7+Mw6Az+lymAmSiFOBnpNEHjav8ElQRWopI72mrd?=
 =?us-ascii?Q?8aoGJEiVs4ZBZxILTuaj7wZaVXDXOIUieh5itm2fmIRKQNlUiW+hIZ7OSpmb?=
 =?us-ascii?Q?iP2DJ5waSYbsItC4HpRMqDzYZKwDOFqRNuAnzyeQA6Jj4ipuVDynSJe5+6qn?=
 =?us-ascii?Q?l8m2nkXVPVdSTltMooDeBsSsaaqpXQRsHHOzSzuSGMIEhK3SgJoRKF3DGLAF?=
 =?us-ascii?Q?Z6+aHtq1GD0CeMF2MHGg3s+fqWCNkPA4bWj5uAv3fy1A9uJ7Czq9ZoK+DS0N?=
 =?us-ascii?Q?klMTCfNLGXA8LBs7DiPk0KG59BuVqxxoUo1gz/SNBTyDo7iE6lJLiK1rx+lx?=
 =?us-ascii?Q?dhlmLMXCSpRJD3ELO9DvUzyWhmUtu6+JVihIBTjbsEi6hUYsvh3CjrjBy9JM?=
 =?us-ascii?Q?wunA8MGNc0tkTn6HrfmQHG0/d7svVFJbQnn6iMuS1ley1Xfw6jxNmBeUnWv8?=
 =?us-ascii?Q?SH/s2/aOeWmIzNwFHN/VNeZhFfu+UymDjumfbbBvmN6ZNGOY7lO3dDCTRqz3?=
 =?us-ascii?Q?L20+1NC1RFA9l++sqD7brLlJQ53A4PB2iatdWAF3lJ4dkXRRirRlvxzGnS0p?=
 =?us-ascii?Q?u2uweTqFETxb605hAq9wQy7wxodXlF8UHxcBbN5zOreXh0HH71MHE+PGXujP?=
 =?us-ascii?Q?DlzYXeKcbLUHH12VwvNMsasJBOYjNh4jcT9/BQ6QvrtdcimbReEUlhXCbWrU?=
 =?us-ascii?Q?v9aeUJ8visQcMhULyYTgWx9ixzfTbuuBMvsCvMj86n9yq7+Va2kDPNQE7x7z?=
 =?us-ascii?Q?Re/foOHtdyS/pmyqZFogGaqFK01lwFmrCPT64mH9IK50HJwvxc3tmOgw6WmG?=
 =?us-ascii?Q?CtOVTmho50T3RbWYy98zIZI2WqkB8j7xQpFUQmbKgQo4l9pOWIN7dqG3dWM7?=
 =?us-ascii?Q?HIrbGAkf6ehX6ziEHgiujrOnVHW5+uySDVCH/CCSDkKBqDEnbtP7/O+kEa/v?=
 =?us-ascii?Q?DJUpzsfPedCZ/xx9lAwUrn6zfbTHq373sicMNGDAn4K8Lrji4VISWUEoIk1R?=
 =?us-ascii?Q?n3eCU3LNSWe8QVWMam51l6Hy3W/GwSqpSFscxz9RqFQmRZl/rFE30GcVN0eW?=
 =?us-ascii?Q?sjlFvvWCHczfTp10bevDboA/bCvNU7I4FKx6B93aDMeXemgyzk0LaPXE7uji?=
 =?us-ascii?Q?/6xGKd+u3w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8e75f52-d299-4a47-a872-08da278eb93f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 14:11:57.4861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fdj/fTuRn7AJ2+q8cx8uIrnDMllMaHF8p1GONouv4KWGz4HlWuvfABB/WYcj/SO6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5934
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 10:08:30PM +0800, Yi Liu wrote:

> > I think it is strange that the allowed DMA a guest can do depends on
> > the order how devices are plugged into the guest, and varys from
> > device to device?
> > 
> > IMHO it would be nicer if qemu would be able to read the new reserved
> > regions and unmap the conflicts before hot plugging the new device. We
> > don't have a kernel API to do this, maybe we should have one?
> 
> For userspace drivers, it is fine to do it. For QEMU, it's not quite easy
> since the IOVA is GPA which is determined per the e820 table.

Sure, that is why I said we may need a new API to get this data back
so userspace can fix the address map before attempting to attach the
new device. Currently that is not possible at all, the device attach
fails and userspace has no way to learn what addresses are causing
problems.

> > eg currently I see the log messages that it is passing P2P BAR memory
> > into iommufd map, this should be prevented inside qemu because it is
> > not reliable right now if iommufd will correctly reject it.
> 
> yeah. qemu can filter the P2P BAR mapping and just stop it in qemu. We
> haven't added it as it is something you will add in future. so didn't
> add it in this RFC. :-) Please let me know if it feels better to filter
> it from today.

I currently hope it will use a different map API entirely and not rely
on discovering the P2P via the VMA. eg using a DMABUF FD or something.

So blocking it in qemu feels like the right thing to do.

Jason
