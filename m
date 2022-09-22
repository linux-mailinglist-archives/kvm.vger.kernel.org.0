Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0018D5E6720
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 17:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiIVPb3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 11:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiIVPbZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 11:31:25 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2043.outbound.protection.outlook.com [40.107.102.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F94DFB31C
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 08:31:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gkso2mr8LKmLF8nkd3fgH17FiMW6oPqUwTuaYAiPcshywNb+AI7KeY2EGB0AYbrSHHdqwZhX41ezXbM43JS8IEZZYFdwiUrVmy1Xb268qmNo56MZjvjXn+nSxVaZdzca0b3cCAeux9UqTmL3lbncFXPe9N7b+8LZBIDAdT69oF/03IKzIiMm4yBcOIa0Z/3M0tno6Ms2FXdsFmrs6tCfWQsJMp50VHxgbCDq9rirN4QOqY1RrmQxcNdsU1+VOGqrW/xr9UJG/TMfHAb6IqMqsirXpJq+Ep8gMLWcK1n5QiYPYJINNOBAfsRez4HROEIHINAKuphbyVbjw9fyKR+a9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fq7ef9dK+PweqZdDYY+/xENw3XQPKUnSABPdxMAaf1E=;
 b=U8K9975Y51Zy4dUFl+9+KjomN81TrRR0zTdqTXHoutHRxeR7iofrFQNc3kpOZAXXHxFQ9X1yy26+DXLcwFEv+4LObI1HkB3/xXhzlWupAtZZ+VN0lcWCIC00wbg5fc1uAR5EpIwoVJbkQzOlj3SJzoJ3xtAHYKiYE9Snuvy6gPqv6auzZBPZ7BRQMccnOYldwyUduuQR3hLdepmcxJDvRwUuJeyxuj7S1rREAWMypQXuUScYQKoCzqtjHjIOUyDwaTL03bdf3Tn3GGHjPgZ7OWTcwtaLdcq1fLvRWVd0Om6y8N8AdPh6AM1hEIQjAHrqrB0H3qD9H4zur9XeTSSfog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fq7ef9dK+PweqZdDYY+/xENw3XQPKUnSABPdxMAaf1E=;
 b=Q3wfxZ1YanL10p1zxjoeE8VjGiPJb4GOCRIWjQhjxYaoOlxp74i7MnfPO55pAs8ZPLMFpf3T8CLuFA0rlUh+PHyMr2P/6Ay9r21ZHYOf+oFkWVQ6HE5B+d+89mn6CcOAtA8i6fqNjwbQ9CknFEwoX+dDdwJvP2gLM6QSq44RkIeZr+CqfMHwGpFx4v9yHv4s0CGrhC6FJFdLMLDtjAEjVxcLzdcErUZwKcJ0bOhbPpuv38wUR73z3Bk4/Glw3EfiGQDOFWsSh6zelnOwGqFZ+toy6EW7EAKqnw7K5kCI3EGGuSQp4qQgdQ5LcABF1VSGbe7wp8AP2rL66Xt6hicCyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY8PR12MB7290.namprd12.prod.outlook.com (2603:10b6:930:55::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 15:31:21 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 15:31:20 +0000
Date:   Thu, 22 Sep 2022 12:31:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <Yyx/yDQ/nDVOTKSD@nvidia.com>
References: <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <YyxFEpAOC2V1SZwk@redhat.com>
 <YyxsV5SH85YcwKum@nvidia.com>
 <Yyx13kXCF4ovsxZg@redhat.com>
 <Yyx2ijVjKOkhcPQR@nvidia.com>
 <Yyx4cEU1n0l6sP7X@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yyx4cEU1n0l6sP7X@redhat.com>
X-ClientProxiedBy: BL0PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:208:2d::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|CY8PR12MB7290:EE_
X-MS-Office365-Filtering-Correlation-Id: e67944e8-84c1-4666-8e8c-08da9caf8006
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xJ0+v50y3+PbZfvKTVFEkJUwjpVQ4iFXC3MvKZyc4mfLFSURft+Y3mFd+UT6BKF61d2j8cblQEUmCwOkFmZ38anJJ/tnzf9xPlfe6ya5Pv/Z4jGUjjytVbSe7F5LowiNaJoGvXC62p/xtjdu0j8ktSMZIOcHJQ8nKpTp0SgkzxnUTmA49lAanZ7E2zpI4aQ2Vx+wurBuf4unayFsIVthcr2/dZzBpaIQmXtdanOVFvgP755HXjv7ZbFzpFFVF3mtCI0Rtpqkez2kYYtSKt08yDlSR9vgzDO+1mQBeQs+Tw5T3tLUa1GMqYXAfHc7D1rDKesu0qofFxbaX65JKS5NtYSjrPHEhBXcK4o25efnSuhLENOyjmYhmGZC9TE9AzqLcGyZ/7aTLgQ4HDfgfHbLCiqV7kkOAo3ziCdHQgyBPENuFrtm1UPOQlTlCyEGen0gbobVC/lK4xRbKVFjUKs+xDLlB6NrWCC8FCDlWpYYMHow3BRLMA4iXUR7J2NkFpoWSUsEjooS/x/qdquPVozO5IlFFA3IHzrefmuqkvKAtXIiw0ObXnF/HMMzodvyVUcKJTXSKC6XRfHm6oqk/Gfe/YDyhf5hgollhHVD0XnpHkG7ymoL2P8gcYIQWNEQDFbOr6t96VtoR5EJLQnTJRf/pm9TMiuk62WDzIbxGMeaexMJ67W0MhOizqUkpHDCQmc4zPdN3K1fXMy0PS0c+5qScHSismqq1v4Z5/2AA7XHtExnfzboSCM9YRbK/+CsT584
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199015)(36756003)(26005)(6512007)(41300700001)(6506007)(86362001)(316002)(54906003)(6916009)(4326008)(66946007)(6486002)(66556008)(66476007)(478600001)(8676002)(83380400001)(8936002)(2616005)(186003)(2906002)(5660300002)(7416002)(38100700002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?am9QamtPd1dHdzJaazFZTGVQWTJNSjl4dFBKTlBFeDBrdjFkTThPQlYxSWh4?=
 =?utf-8?B?UWw0YVdaVHRGRWN5cXUranUvUVBEVEJmbkd0Wi9WNkJ2a042NzNJWWVUaGtp?=
 =?utf-8?B?OE9TNzRSUlBNU0RUTDBoTHEvVFloSzU5b0VUcGpKQnRIUDlvMGgvS1BFUlI5?=
 =?utf-8?B?eFRNeTZEWUh3ZzBQQXRob091b3paZVRhTXNyRjk1SGYrMS9kWU1QMFYyK2ZH?=
 =?utf-8?B?OXFqV3djNjFIZlFIZTk3TWxkck50NEFIMWhpSUt2ME1iMHF1Ui84WjB1TmNQ?=
 =?utf-8?B?NFIxUTN5SzBKZjZOaVlIZFlHMERKUzRJeFREMTEwQk1IRlJMSUdnZE1Neklv?=
 =?utf-8?B?WmR5NXZrVzFVeWdyS3IwYWhxbEYySWUwc3pWeHloMFlxWERqTXE0ZURTSGRz?=
 =?utf-8?B?Mkl1ZndUdm9wOXRiY011STNneVpFWGhvQXhUZytUZDVZZHNvZ1pQZThTRUtK?=
 =?utf-8?B?YXhDL2d0NU41OWl6RWlLM1FuWHhXeW5zK1ZQb3ZyanZ6T3ZRc3Bhd1lEUXBS?=
 =?utf-8?B?OUl4VVR4YWZHTWhybWFnRit3Q1V2dy9GQ1lBUEY2VHRmZE90NHZWVjRKZThs?=
 =?utf-8?B?MFNkZTB6eDNTNXpIbGIzZngzL1lRREtadTVCQUJSY2N1OW5JNmIxOGlmT1k5?=
 =?utf-8?B?SUJuUyttN3RJbHh2TGVVQmpCT29mZU9jbTdSNkEvQzBTa0V4dG1oaHNGWHYz?=
 =?utf-8?B?azFZUEdxdG9PZ1dRRkZyaE94cjE4dlBZcDZMLzBpSGJ2UVNxOStHYU1vRGpT?=
 =?utf-8?B?RjdTQ1VoT3FJdXNPQkplc0dudXg0RlFRaUUyUFlBUjUrY3pVUXZUcnJWREYx?=
 =?utf-8?B?bmhCeGpqSHdtajlCWXQwcGhOSW5xU092U0haaVQ1VWZDdEtMWHJVcW5oUzNH?=
 =?utf-8?B?bWw2Q3hxdFp4TU42QkRwd1d5bGFwOHBsVWFPd0ZuZ0laTlkycjhMemtMOW94?=
 =?utf-8?B?ejdIUS9uSU1yTDB0VDFEQkJiWlcwUUk4d1VCb2JjVVFvMXRzbDlXQ0YrYlNv?=
 =?utf-8?B?aW1XN1pmUXhWSjczZ0xhVndWUFU3Si9rZTE0dEwxSm1KWVRhNk9WTEhqMlox?=
 =?utf-8?B?Z1A1UERoQ3lqUjVYZlpzNDRjR3hyNXRQMm9VL3ZuYXlDRHBzTkZSR2N2a3h4?=
 =?utf-8?B?WjlpR1picFRyWFpaM1pGVkZ5NXBITngzLzhyTUcrRTA5L2hlbXBqMGxyWUt0?=
 =?utf-8?B?N2hrUmJLV2xOV215d09Fc2VtWDhwdG40Qm1wYmtSOUdpOElBeEFrdENGeHBj?=
 =?utf-8?B?bms1YjBPSjBNL2x2YUpRVFROcWpqTTNINUhLck0vVGtVUVdRWGdERGJzWWJO?=
 =?utf-8?B?RlMvRm9PL011OWpVS1BxSjk0TTFDVVliNWhHd3RadTZDcktUMWNkMlUxdUpn?=
 =?utf-8?B?SjB6c2pQbnhMSGtPUHp1OWR2NDBiS01vbVRITVBiaFU3enhvZS9meXcwNlJq?=
 =?utf-8?B?UDkrYzBGbnFBanVKWDRvSTNhOGZtcmN6VFZRcFcyWWgwTmxpNHpsMnBEZFJO?=
 =?utf-8?B?cWpWeUp1cGJqZG5YT1V0WUFKOU1SeUQ3eUZDRUVhQ1RkRTlHb2VnTVFwdFRj?=
 =?utf-8?B?L2tDcEFWTUNMbm1Eb1N6NHhSeWl0WmRLUXdiMUpPdkFMR0Y1dlA2YWhnWlZQ?=
 =?utf-8?B?aDV0clBmb0k0TTVKU05VV3dSQUcvQjZJSklXRXpFb3kxQm1wNlFzaEpQS2hG?=
 =?utf-8?B?UW1Ma2NBeVVKWlhVb2grTlVRR01BTUd3OEFBWDJUNlloQm1vMHNtWU5ZQ3A1?=
 =?utf-8?B?REpSSWUvVU84bU9GN3VjRUxhVE1qQndOMjkveGhIRi84Zzd0dStXZTJrL1Ur?=
 =?utf-8?B?RGYrNVJIZHhWTEc2YVpkU3V4TXFaZ0pCWGtTZjI1M1VWVzJCUnNhN3FNbUxw?=
 =?utf-8?B?LzdFZWpueFBnMi9sUHdoOFBjOHpCNjMwK3JjTG51U3ZDbk13TnBMWlhFcVBJ?=
 =?utf-8?B?TGFRRTk2Zm9WYUZaYzE1SUxTWVhWVm91OTNoZEk2ekg4OGdCZXlGK2Z5aEZR?=
 =?utf-8?B?QlBqdk4yV3Z0SGFvdXBNVm1tY1dkOXlTdDh4YkgrQ0JWWStXL0N1b0crNWdW?=
 =?utf-8?B?dkdScHVjYnJ2ZXhiSnFvRUZWWWRwczE2WmxNTG0zNVlDR21CTTdWODA3Yno2?=
 =?utf-8?Q?aR9A6f+0a1Kj6IE+01RK1axPb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e67944e8-84c1-4666-8e8c-08da9caf8006
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 15:31:20.9031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XwunGhBDc5k/CTEDQ5qzQYx9AkGXvJ0fBXV47ZZBfHqZQmTwwiSwu0960cQIVc1d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7290
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 04:00:00PM +0100, Daniel P. Berrangé wrote:
> On Thu, Sep 22, 2022 at 11:51:54AM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 22, 2022 at 03:49:02PM +0100, Daniel P. Berrangé wrote:
> > > On Thu, Sep 22, 2022 at 11:08:23AM -0300, Jason Gunthorpe wrote:
> > > > On Thu, Sep 22, 2022 at 12:20:50PM +0100, Daniel P. Berrangé wrote:
> > > > > On Wed, Sep 21, 2022 at 03:44:24PM -0300, Jason Gunthorpe wrote:
> > > > > > On Wed, Sep 21, 2022 at 12:06:49PM -0600, Alex Williamson wrote:
> > > > > > > The issue is where we account these pinned pages, where accounting is
> > > > > > > necessary such that a user cannot lock an arbitrary number of pages
> > > > > > > into RAM to generate a DoS attack.  
> > > > > > 
> > > > > > It is worth pointing out that preventing a DOS attack doesn't actually
> > > > > > work because a *task* limit is trivially bypassed by just spawning
> > > > > > more tasks. So, as a security feature, this is already very
> > > > > > questionable.
> > > > > 
> > > > > The malicious party on host VM hosts is generally the QEMU process.
> > > > > QEMU is normally prevented from spawning more tasks, both by SELinux
> > > > > controls and be the seccomp sandbox blocking clone() (except for
> > > > > thread creation).  We need to constrain what any individual QEMU can
> > > > > do to the host, and the per-task mem locking limits can do that.
> > > > 
> > > > Even with syscall limits simple things like execve (enabled eg for
> > > > qemu self-upgrade) can corrupt the kernel task-based accounting to the
> > > > point that the limits don't work.
> > > 
> > > Note, execve is currently blocked by default too by the default
> > > seccomp sandbox used with libvirt, as well as by the SELinux
> > > policy again.  self-upgrade isn't a feature that exists (yet).
> > 
> > That userspace has disabled half the kernel isn't an excuse for the
> > kernel to be insecure by design :( This needs to be fixed to enable
> > features we know are coming so..
> > 
> > What would libvirt land like to see given task based tracking cannot
> > be fixed in the kernel?
> 
> There needs to be a mechanism to control individual VMs, whether by
> task or by cgroup. User based limits are not suited to what we need
> to achieve.

The kernel has already standardized on user based limits here for
other subsystems - libvirt and qemu cannot ignore that it exists. It
is only a matter of time before qemu starts using these other
subsystem features (eg io_uring) and has problems.

So, IMHO, the future must be that libvirt/etc sets an unlimited
rlimit, because the user approach is not going away in the kernel and
it sounds like libvirt cannot accommodate it at all.

This means we need to provide a new mechanism for future libvirt to
use. Are you happy with cgroups?

Once those points are decided, we need to figure out how best to
continue to support historical libvirt and still meet the kernel
security needs going forward. This is where I'm thinking about storing
the tracking in the FD instead of the user.

IMHO task based is something that cannot be made to work properly.

Jason
