Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9541563FD7B
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 02:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbiLBBGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 20:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiLBBGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 20:06:39 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63702CE439
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 17:06:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4wngHqTCn+QD4r7zWlhKSZtYmDflJ6MWg18PFYj4UXIyE5IatAhXyT5CDfSJ16ofjKg7UEp6aBib0+pJZLOPPX/FbtsqDrrZ1fZmx+w70dUXuMGfDAJkmy06Ewx9fDWJqoBRYcz9o9KqwcWamxdZ/bQU9sfJLke2rVnWzM7yiNnrrIppBqMAsgNcykG7y/0HzYG1dG10rvqTYUzZjQhFNDYCDNqeeiSNfXA4LcTC5/xTx+nm8+ObCd1CYoRuEFQKJESr2Av0/YXP7nezWnE9eKYS0Addp7+o1eBQi2xlEuU4KZpyR9qHWCQTiQmimI/D6z6QBZz3iDrOLgQXgXELQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hoNmZQzNElv7Vwn6aRrwiubBX6SHk7LYmHl/O2Nibqc=;
 b=RgwsFEBlbdamqR25APuYqEY6R2l11D91eSHikRYka6pUWRNNohZHpOSPuSBZbcpAmrGBjIMehQWChMGWvfsz1ZH8tJggkPpgV+5VuKElZ/Eo4POQXWMqV/rwqB6n6iS+E015YIeez9GRVq1gR9SWi9v6oIXxRaSYz966WXYq+JzDoXpHnmMwOb2CQQhoC3PDK3frUA+9LCPg5f7xMzic5ZiBsBALD1zRjrraCAn/l+aFLAVMBZjw/zJcFXHElc4T16eHCl01GauLnMiZszYcWdcgVhA83eLaQ5JreFxASyYgawsBjYXzgfZM3U/IxPBnOtru/noUbzLorRocw+B21w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hoNmZQzNElv7Vwn6aRrwiubBX6SHk7LYmHl/O2Nibqc=;
 b=Ut6lJ9pfWNHufxjmE04NxGeKiSB2uHhMsU8ga42GZ3FOoLHpCsY904jo5eVJU/dL0ThoC2QdD/YcPsMDSJ7HLTPzV526yh63MAEMPlbvMF/pFMcEM/5Cb2oVaWKiw4QwJFpqsKOlLoE6s7hsYcPI5C5pi+dUv4fZixcTYHWjw7867ijx0iG7UAs9/IIIR7DuWzM3MVYYvuUDX4Xqhh2S35RH3E52t6K3fyq3aADNqzaPBmQDQ7KkmkX+73V9gJEoDgoGr+SexiEEbboSqVyrnOWFCwB6qNrBffli1m5pU+u5qHFuZuZckCxNSeV0qRnpTpeKA3pcFpCNib5o9jCouw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 01:06:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 01:06:36 +0000
Date:   Thu, 1 Dec 2022 21:06:35 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        shayd@nvidia.com, maorg@nvidia.com, avihaih@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH V2 vfio 00/14] Add migration PRE_COPY support for mlx5
 driver
Message-ID: <Y4lPm4ZYYfn7gUTh@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201152931.47913-1-yishaih@nvidia.com>
X-ClientProxiedBy: MN2PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:208:23a::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4181:EE_
X-MS-Office365-Filtering-Correlation-Id: ee0bfa9b-39f2-4818-8508-08dad40175f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nuMi7wkedmxPU2rc1+9d0Sfht7em31dyz/rISAhFT+PRHF1tZsX1IC/X8xxP8z+DmUKZZdROFmSX5Xy9AMOhWiF5H1hE3gVxyaWJFSg48KVlJIUO0hVDsAs0dE8AHyBabIQ+gwrtg30/6nmy09DltrxtBbpoNo4CXjfLMDzQM7v7TW4GInHJnDhmofTriT4cQ9DLJq8tjvaSVEKHmhj1h7ZJmGTregppBrkBb0nqrdZFKjFuFe2YFZvJG13041txGv+LzY15bQz5+meodKm4UBwC0aUB7OmoSsZhtgqyhEGQaezqU5JRK/H7gok5tRgDsW64WEh6ZkQvlFVphL48toL7GagtnQuQIIK/051aqHoKr++PZcvf4F1lnNL6tvXX48vIFI3+XpFnsDK5+wjH82qm9WR30+blkbf2clZW7KcI+xcjz7tzZwKZXB6SLJj+S2brayZT3r6uCMwkFN4/M3COOG2SDeNsenf6Ki8KWysAfrjO6boisFOpoNmpOApvkiZw7yGSi27Cn9dAaRE3gFKUE+SMmor6o9VavV7zhYXo6OZF27ip2YgdEdQobgCbKvpsaMbZ+SOVbLaRlixlrWN619mT0XOv+F1CMqrnoePeig9pua1NjyjUMZPdS8iuUVhkoyEL/deS7hSGMs9c6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(451199015)(6506007)(6486002)(6636002)(26005)(186003)(6512007)(316002)(478600001)(37006003)(8676002)(4326008)(66476007)(66946007)(66556008)(2616005)(41300700001)(8936002)(4744005)(5660300002)(6862004)(2906002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Hu1I41YmgQk/f5OnAymSj89bBZw6Hk5BDia0VBEFs/meBjFbE/PJf/ZB/e8?=
 =?us-ascii?Q?Ui4w9NzlAbvFpHv5X3QlyG3GILYv1SNlt2V8/BOn+PL2fXArP1185+wy9zTC?=
 =?us-ascii?Q?IpJmglMypNTKoYSMfVuL2cAnMo4rNf3wKORQcZ4BoTkTzy1A/ExaBiBbXbHM?=
 =?us-ascii?Q?FWH8gXf7JgpYt1VJB8fPc1d2RmjxdhNshX0LJf2X66nPGT+Ug26WKILfgTfu?=
 =?us-ascii?Q?ppohtaPhi8QuAzYo26o9XTknciPMCGq+Cx2HpOrD/nV/Jh61fSgs99x8lSSR?=
 =?us-ascii?Q?7s3xxKFejQGzV2f2jP4QXwNhHLZJtezk3uY8Z1RmVof4YrA9zOW/OHOpdVCr?=
 =?us-ascii?Q?BbGvwvKeMwngWzJE07xixUc+z0/JVYMYqFD21zBOgL3t2B6NJmYHxdV6zJNR?=
 =?us-ascii?Q?4D6pelarVRPVjoGDK3HOYeOFKlSA2OY/dJHV4LC14VP/cI7AbEJGzjgTkcaj?=
 =?us-ascii?Q?1Xh6zBUGNhSP6jLFqoDGvUER2gM0E2WRj17RzM10owK+nyrSEtDIg1OlK7Fk?=
 =?us-ascii?Q?EXGOVBcZueGCcEYsvg61DIq1GFunLcY2roMGIn/+l4OZfK1w6+peYIbpO0Jt?=
 =?us-ascii?Q?zOnpmSMN0/BFBBBP32mCEwhXASShwjCY5fEOnnhq2hRGDcyQhedTYzcseTjf?=
 =?us-ascii?Q?prq6kBd48fGQYwGpievKX+zHRaMHL8/btwizQjY71zCwzm5NtusL/1mg+z9r?=
 =?us-ascii?Q?SoeubpGb5M7b01Nv2uoFfoyaFnA6h2DU2uEHQaYY9t3axZjPjf5wc5oD6S7H?=
 =?us-ascii?Q?Apq1HMk8MB4TWlwtG0upN1wbncjJEGKyutPcdSRDxkyGLITTcvo2GBMvrMJJ?=
 =?us-ascii?Q?ikb+rrRgUmRbLufTEt8nVv5o6VYyxVkVso4MU8goY6W6K5QsLzQ1rbSVnQeg?=
 =?us-ascii?Q?Xj1IEt2B5a5jXLYSf2YmlOs72/rDPZjT/n0yLQ29+qIR2cBnjlQCVBx2SXMZ?=
 =?us-ascii?Q?GWbk+QSFUzDomLod9s2V1yTAlJ4ENVtDK7AXwhWUI/r6OXx0Cp4C/FKvmOKC?=
 =?us-ascii?Q?fad9cTd5sCxM8z/SAFw5fwVvcLmEIh21YTKOZl+3xmuABkW+T+405EUxP1n1?=
 =?us-ascii?Q?60bpMRym9cDkn8g5qyCFidk4gPGOcUXASOJxcaCXiY3XUt4V7oMh+flkZ0tN?=
 =?us-ascii?Q?aQYFTGZkpQ9g3bk1tpq1TU1ASAqz8jxPDvQQ2AlRQXSzrRU3ARZpgysUuZfB?=
 =?us-ascii?Q?PKYSbv19Km/ZsqivgVUEq8ElOGDUV7CQlWUfFmQgGSomVb1AtiyJ86sD5+cp?=
 =?us-ascii?Q?EjVF1czKNBE0cKSam/WTx4bjhC33WBBkz++jXcXfWGS6a3SSwly1OdQXpZeu?=
 =?us-ascii?Q?DoAN51QWV4HnZZuK9Hzp/hLdUFVbJg78m/DINd0+Eu+PhlZfI/NqI9DAxfXr?=
 =?us-ascii?Q?F50FPF7W7tQqHr35+dDzlvB/EWojULBq0TSATvXnG6pKkYgrK3W+6SkrZ2IW?=
 =?us-ascii?Q?FMMlfpfA++XQCcscQgdLMZ3aJPWbxyqddzeCQyV2t7xcC7RIEn02DVo23gs7?=
 =?us-ascii?Q?qQnel7thPmxzSStkLBDDKom1/tfWNfcbNZk7423+x4OMy6X2fj/RauHma6Px?=
 =?us-ascii?Q?nwr7QpBMDkiICDiER2M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee0bfa9b-39f2-4818-8508-08dad40175f8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 01:06:36.7186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcWjJF06EbshQVxhlwwfgNvg5rPmKPpcMK2olE7sZLQHvEeQKpchXwuclJNuzgQf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4181
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 01, 2022 at 05:29:17PM +0200, Yishai Hadas wrote:

> 
> Jason Gunthorpe (1):
>   vfio: Extend the device migration protocol with PRE_COPY
> 
> Shay Drory (3):
>   net/mlx5: Introduce ifc bits for pre_copy
>   vfio/mlx5: Fallback to STOP_COPY upon specific PRE_COPY error
>   vfio/mlx5: Enable MIGRATION_PRE_COPY flag
> 
> Yishai Hadas (10):
>   vfio/mlx5: Enforce a single SAVE command at a time
>   vfio/mlx5: Refactor PD usage
>   vfio/mlx5: Refactor MKEY usage
>   vfio/mlx5: Refactor migration file state
>   vfio/mlx5: Refactor to use queue based data chunks
>   vfio/mlx5: Introduce device transitions of PRE_COPY
>   vfio/mlx5: Introduce SW headers for migration states
>   vfio/mlx5: Introduce vfio precopy ioctl implementation
>   vfio/mlx5: Consider temporary end of stream as part of PRE_COPY
>   vfio/mlx5: Introduce multiple loads

This looks OK to me now, the logic is clear

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks,
Jason
