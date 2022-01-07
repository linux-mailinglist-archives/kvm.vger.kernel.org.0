Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27BC487108
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 04:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345762AbiAGDHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 22:07:34 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8910 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229616AbiAGDHd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jan 2022 22:07:33 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 206KeXSG016696;
        Fri, 7 Jan 2022 03:06:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=WSjqvAYm3l30SwRQp8qUHRiurme+VTRhUz1Jl63xCXs=;
 b=M3x5Eq9Q9OZxRVbIZ0VhxOV2LQOU33A4Hz3GqT+axdGPKHwk3tUGjdsaVOL8Bv9DVV0m
 JUCGStVJhwaOz4E7qi84xeUDtSaAH7Kx6URMNeCBrttsQBKY3Dwy9g35B7EL2UYidDZj
 pgn0ZhGn03JsddFf9fYhNdJLUQvAv0eyStcVeP40sL+vMFW/3V6zzPwmyf7WqI2x98aj
 sateXwj0tjOlrD2FJ0MCvY8UdHElP1evHl9lwopz9tEObe69MBD9wg5zPW57tyqQrs8Q
 dDWS7c8hisQOjkn+fZxwerUhm6D0famCg54VJxVdn6JPQfpB8fJUjN4d2Uml3YB2tfLz NQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3de4v890fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 03:06:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20735iaj072575;
        Fri, 7 Jan 2022 03:06:48 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
        by aserp3020.oracle.com with ESMTP id 3de4vvpn5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 03:06:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YwqLCtgQ97CIoA0ViXwJMGI4xgUk0cw715OinPnH4uWR7lqOSWr+BIbuwVhJX7qDg4I46XwTPMLncyNVpg1eqlzxIA1xFoNKenmPfdEm9DRo3TbXiEhaxYvIcmk3SO6NvLhe1nbQgKAWgDj2PsHKkHPpcN8M6BSqcf8gxtf+bEn4XkM7bM0st5aFBvWsvax33EGqP8CorYz2anpKSYa8+v8UP4GVFS/GYS+uXsre/74oIPg5Yr/yHpuefrnk+/+OChbE6siJALqpSwtHtn9kOTHXpjroOuWL0qgIGheKc9Gwxoe5F8Z3aj1JT5LumzcHJ5VG185tu86G6Gsy9zOgfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSjqvAYm3l30SwRQp8qUHRiurme+VTRhUz1Jl63xCXs=;
 b=K+GfKz4XSYxABjCiPTEstvFqIyMdgN37MZXlO6ItCkIWlX9w23zzkTUsw484JLsWr+fjt/wFlJ2LwaZDHizZUDbst4t5WEtp/XK5dsWCwa/evVddv8RbwfvVNFTHmo5ApWpNqGXTKvWU/05gTr6fETQMoL/qOpR9PAUEkoBl4R9X/DmMnkF5QGQuyFFjWbq4O2tpdptK9ciSXCn+/Cs5AMrPnqdweZYsTLyM4p29TucPLvuqdwop/ugtpb8/uzprOLj9e3c9l9HIKUyqkrXBlX08euf5Bfnms+/TPUScOLK5E7y3iRmQWXkf6EhgKCM1zrKkesvieplT63ypsULA7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSjqvAYm3l30SwRQp8qUHRiurme+VTRhUz1Jl63xCXs=;
 b=M5ctkzV7pssSgQ+eYgG0HaAMsb7pozM6Mw7iSQTnZ7Ap0WXyAazQPDrLf8P45spzZwObSaL4Ws0OSaxP4LlD/zATXARaMZyQ3Bo8OWWb15TJo4FHDKF10vUS+/OVfCrYU8/tolHyz1ZA2I2pQDys2tg7sxbpEevSOHz2Wox+Lxs=
Received: from SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20)
 by SN4PR10MB5542.namprd10.prod.outlook.com (2603:10b6:806:1e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Fri, 7 Jan
 2022 03:06:46 +0000
Received: from SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e]) by SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e%8]) with mapi id 15.20.4867.009; Fri, 7 Jan 2022
 03:06:46 +0000
Date:   Thu, 6 Jan 2022 22:06:42 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 08/16] vfio/type1: Cache locked_vm to ease mmap_lock
 contention
Message-ID: <20220107030642.re2d7gkfndbtzb6v@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-9-daniel.m.jordan@oracle.com>
 <20220106005339.GX2328285@nvidia.com>
 <20220106011708.6ajbhzgreevu62gl@oracle.com>
 <20220106123456.GZ2328285@nvidia.com>
 <20220106140527.5c292d34.alex.williamson@redhat.com>
 <20220107001945.GN2328285@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107001945.GN2328285@nvidia.com>
X-ClientProxiedBy: MN2PR16CA0020.namprd16.prod.outlook.com
 (2603:10b6:208:134::33) To SA1PR10MB5711.namprd10.prod.outlook.com
 (2603:10b6:806:23e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27800304-d008-4e63-3c79-08d9d18abd47
X-MS-TrafficTypeDiagnostic: SN4PR10MB5542:EE_
X-Microsoft-Antispam-PRVS: <SN4PR10MB55428A2C67789D51A0C01ABFD94D9@SN4PR10MB5542.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jDeFYEOKPW0jQMVH8IGccoYeLMYK7zavY0A2oXm+e131VlF0qSbDMTZ4kBbwzlbg56tL4VQ1VhrttflA4wZPqd//EEoNsMCGuB2VjN8b85v1L4uGqyu5P912cNyhkk/mZs1oWRfXkJzfQk/xA19abSa2GcAVhA3dfY9d/nAu1bQN/SV62F1cILguogt26LohX0W9hfpZ2IL7Zd2kOVfIwZ7Yp8ORXY/fEQEswTb6drIWdz/ogaWG7Iq+r/vEttNpUbpDCVfQHS1LXc7jFTsuNzaiOiqCQJSOS0Q7AIh1Ik7CWxB1itOsYIA46OYPaPIdlKdGqIN4vKB1fSUcbznbsh5tth07Va15ZgdHK/4v+qHpcmt/3Y4poN4uEc8aZFry+7WhT9GrRLVAgesN5md1dapcQZRHXHxYEFy4hmjzFd79CVHrXHdrjX5aSEYtXwYlDAA6zhFD1WX2IpPH/0DynIy56SPyDGKaX/kWuXVCJOmcvpUDzrmiL1kRqiUMYdfQLwCRMYFak0X9WnJRYZHq6KWM0EST6lIkOwfTgFZm5HANjCA3TtlDCbYSSfyRaYb+8pVFgJVtm/xAra3Uj8HWQQLLmhkWnEl19T7TV/tUayaKLnbKzHprEJznmvbiyXohtvSeH1biEvXfgGRgcEGPx6Or16xwcMtvb2odRd73TtkvZXs2ujW9WU2xcehUIpDnfkc6dw/FAyNgsLteGLumKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5711.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(1076003)(38100700002)(38350700002)(86362001)(83380400001)(66556008)(66476007)(66946007)(2616005)(4326008)(508600001)(6486002)(8936002)(6916009)(186003)(316002)(8676002)(54906003)(6666004)(7416002)(6506007)(36756003)(6512007)(52116002)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6E7guNOm6x+rIfSAbgFYGuRwJom9XcHVR0YS9o3ZlTxlYk7qnFEroO5Q5o0U?=
 =?us-ascii?Q?4N3uDhyDeMTQ1W5PO70WW+9sKjCtTufk/aa0QQd2EQoDnPN1DOGbMolFhX4/?=
 =?us-ascii?Q?QxwTYPXzoLhASv0ZQRCgAeIiGGaPvE29V5tfNedRQftl2ANdejhC7AhXy7/7?=
 =?us-ascii?Q?poilQ4zWsPavNb15pFxReOVdhMxU1ubvGROsBoPcahQHAdX3rh/9K38iaDQy?=
 =?us-ascii?Q?ltJYI7u1LMMJ0BrKgBGjcdfGhir/vvJ2CBrKHnPuhJcIz9hPMKRfQjGwUlnl?=
 =?us-ascii?Q?PUY06RxqAQ5mfFxNzRogwsNDdxdrHoQ9nIfkIzUsDIdMvdPs2MDvnb+6FMv2?=
 =?us-ascii?Q?qePDEM90xwRtA9tNQZ6wmie68E7wlQEmdhOeDpHJ2BTHHuvPRVWrycH3m/Qa?=
 =?us-ascii?Q?iTH2Bcab6+kT9uypkUK34UeuC9SRPmi9/UqCOhxzJJa1posj/GG1DI4RKRWW?=
 =?us-ascii?Q?PgQ6qq3P9afwRHT7gKwtxKxz5y/FTCHMGFuldrXFJpR/6rZSlgACw4Mhs5fZ?=
 =?us-ascii?Q?PqV7v7auyg5KxdPm2vB8AlLW/Xjbvy2uoSwISMTBCtSysN24I3D9W0pqD+yV?=
 =?us-ascii?Q?3BP/Jh/PQWdlaV5feJOGSHtm0UZ0b9uWj/35AVxf0JMzPLpcNs+noNL41iQX?=
 =?us-ascii?Q?ZJhRf2xbC1P8pjQJ1xX7bgAQk/JN3NygRVPoWk0lz8yCQ0/X08BiUIohy+IW?=
 =?us-ascii?Q?2rMggN2Ow0lNPFvTyJtyAYVwOP/eLIKAo8tahjsDc87Fc4E8tvxRWXo0ueU5?=
 =?us-ascii?Q?bo836qtVYxTdSWN7FdnY70mWUCxwRFU4JKfFMzlAhtFLxr0mhks0zsCATeFd?=
 =?us-ascii?Q?geeH2ZvQxrOER3shaWXR8re1vKVdxyflgx9EB1YMXwaIPL2kDicFvPSmQ6YF?=
 =?us-ascii?Q?ACqOma4VkCRDjSaGR/EYomqhajG9sLAzBJywISNdIPDyX7pCcd03PmEogMFw?=
 =?us-ascii?Q?0B13qRo2JQ6MBLQZaekmZdQqLHbTPi56uoubgVYn7YpZF7hLlpqvfmo/jmhk?=
 =?us-ascii?Q?Cf4bLr7XJNriZ4cVPTseaBE6IxGp4PKFzNuL6Stx266/zMGcMIEIBMUsuFMf?=
 =?us-ascii?Q?EyOzgx065To6wzbOw60tkOfDRsLoRapCfz7dysizNhqg9RpZ/N+pMAjqFMwE?=
 =?us-ascii?Q?GAhxtoo4gadPrS4ajCO5K/httVITJptVMLbQ+eknc0ONlLBhP3WRC08N/THE?=
 =?us-ascii?Q?OIot5JdE0xdCJZmWGMG0NSkpNZ1+sQv7mWs1/wFWBWmcicvG6udTDES1js3+?=
 =?us-ascii?Q?HcIXcSLhg7zSGkxCdhKvVeP3TOfAzl7pmj73qWEGBESxV9W+b13vHcbU+bCf?=
 =?us-ascii?Q?wQc7s12n58/7kOEOkXOfF+2NuktTTz5TKyzwJHfVMp17z0bsMeREHqse7Cmn?=
 =?us-ascii?Q?/seqVwx3V221odsP855U42byW2ZlZiqyFEez/Hrhsq5ufN3L3+0kO6IhFMU3?=
 =?us-ascii?Q?7cSEQlDukEj4p/z9hFKDUs1Be447f0oEMEFNRZH/oq++7trgoe8V+v+09W9w?=
 =?us-ascii?Q?XUCSAS4jEDcSaUJ4st2MYEneRH7KXuiY8uZ3TFomfQYtmKRniCFvyjEejXJC?=
 =?us-ascii?Q?a0r36t7mpcNofeOzxu8S+/AeC/+zuPr1pYkFrFX+NFv3wrdGwbAux84bAYb7?=
 =?us-ascii?Q?aqwcDET2jFSkGiAOps3GYGtJ3S5PFY8SB1J2qqL4ocZCbj3k8EYRPYitZwIX?=
 =?us-ascii?Q?57h8bGaqDINhjSziLqzkOOQ+JNw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27800304-d008-4e63-3c79-08d9d18abd47
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5711.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 03:06:46.2295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kSqkpAJdWhMg2m1gDJWOJTxnzIEB8DYinKNe6v++iFDOiltaomuyBZNTY41kqdOPbBx92ahHx4ckopZ0dI8T0Rs6Kno7FpV7ajHRQrmOsuU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5542
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10219 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=885 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201070019
X-Proofpoint-ORIG-GUID: XV9TbI3A-uQHkC5gX9eU4PKcL8lLefj4
X-Proofpoint-GUID: XV9TbI3A-uQHkC5gX9eU4PKcL8lLefj4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022 at 08:19:45PM -0400, Jason Gunthorpe wrote:
> On Thu, Jan 06, 2022 at 02:05:27PM -0700, Alex Williamson wrote:
> > > > Yeah, good question.  I tried doing it that way recently and it did
> > > > improve performance a bit, but I thought it wasn't enough of a gain to
> > > > justify how it overaccounted by the size of the entire pin.  
> > > 
> > > Why would it over account?
> > 
> > We'd be guessing that the entire virtual address mapping counts against
> > locked memory limits, but it might include PFNMAP pages or pages that
> > are already account via the page pinning interface that mdev devices
> > use.  At that point we're risking that the user isn't concurrently
> > doing something else that could fail as a result of pre-accounting and
> > fixup later schemes like this.  Thanks,

Yes, that's exactly what I was thinking.

> At least in iommufd I'm planning to keep the P2P ranges seperated from
> the normal page ranges. For user space compat we'd have to scan over
> the VA range looking for special VMAs. I expect in most cases there
> are few VMAs..
> 
> Computing the # pages pinned by mdevs requires a interval tree scan,
> in Daniel's target scenario the intervals will be empty so this costs
> nothing.
> 
> At least it seems like it is not an insurmountable problem if it makes
> an appreciable difference..

Ok, I can think more about this.

> After seeing Daniels's patches I've been wondering if the pin step in
> iommufd's draft could be parallized on a per-map basis without too
> much trouble. It might give Daniel a way to do a quick approach
> comparison..

Sorry, comparison between what?  I can take a look at iommufd tomorrow
though and see if your comment makes more sense.
