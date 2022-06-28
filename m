Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790B755E95D
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346892AbiF1NuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239560AbiF1NuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:50:03 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2073.outbound.protection.outlook.com [40.107.101.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C336ECE0C;
        Tue, 28 Jun 2022 06:50:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSHLLYA9tRqu3PmNwnPObA1PuseIB/uigp0XUmeYX6v8IA4MyPvitxyzz6X7igXAgLU8OctQZvm3Dq6uYnHHt6ew/RdRoHj0e2tuzvBYcEy4migTuLsEUmQO0gc7soE49Crw9oWS/YRjDHkutjZ8PK9kGe9ydH1rURHMzxQyJ5k1vTuYoATtaPTGPgv4zIgHUYOpkFeBRUcpD102/iKuqJBL0mjwKaYw3Fvg6kCBnrYPV1hBGzoMLhkxR+9a9YyWZIitC8cA6wShYUW5/FJ2U9J8e3ACa7Bqw1X0n8AXJl8KR+RjZYRJ1kAtjoN3kj7hQ2FbNfB/X/zMBWg8qE1iWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjGPUmm+iAsADgV8wJqr9BjOERwlMuCUHxq5t5ZEEN8=;
 b=jwrWl1HBKIRmYbflVbPDfUhkWnE2zMVIf2H/ho6RZxcvMEVcaOmmKfUraJLuIFPE9hKt7MzjCf4lknd3tZsMVFxFXbUy3kgzhMZczi8ANV2IN5FEQZdgmK/oN7cm1lnKzDk1enJdjB6Stzp4m5NdaAMCZqiLmMn5qVQB0T7A3pgH9uZC++9zp63E7/OAuh8T7F+aci3EfbN5HAbVXKL3Zf4IOKvmrc+HNz/aJE9zmC4I7d1Ahvx4IJ39az6Ztp7yxfb0A2PZm6PS+hMAeK1roih3NZTQGWf2ygmd149tYHZPpvbwbqBo+pXevbHgXSm3//H0qR1Yqs7vRh33eiRuZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjGPUmm+iAsADgV8wJqr9BjOERwlMuCUHxq5t5ZEEN8=;
 b=ecFtCjtKX9ExcZJSjnvKpeFvvm70vxVv09AqGsPFSb2xP9nNZ7LUSoROPhr5tl7zbkJp7jwjDie4HDyb47nIe5hvxg7hc+cnWWhzx6UTIqcwyVTglv7N/XDKrVm5UdeR+CSAkcYjIKyD9hnkcf2cDLClYg0H4mjkTvpToEZvUgTXxwFrjt/mzY5ZKTo1n5Sc6XD+GMzRFIgG2+I3PmEdz92JJ7N5Q7Hv9dgZVaeNN5fimKnnIG8E09aZqkudN1ysmTYUynsyOEOwBdnifsOHgPJwGuol3/znsCQDLgbJTMBdBSHy+2hVbLlSLXPQMT+lI1jHO66arx4rr9pwEmHw/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by IA1PR12MB6459.namprd12.prod.outlook.com (2603:10b6:208:3a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 13:49:59 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.022; Tue, 28 Jun 2022
 13:49:59 +0000
Date:   Tue, 28 Jun 2022 10:49:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v9 00/21] KVM: s390: enable zPCI for interpretive
 execution
Message-ID: <20220628134958.GB693670@nvidia.com>
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
 <f86e2e05-114a-cc9e-8f3a-96b36889063d@linux.ibm.com>
 <c98e7c10-272c-2bbb-6909-046d57d721d1@linux.ibm.com>
 <425d3030-94e2-efeb-60fd-08516443a06a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <425d3030-94e2-efeb-60fd-08516443a06a@linux.ibm.com>
X-ClientProxiedBy: MN2PR16CA0033.namprd16.prod.outlook.com
 (2603:10b6:208:134::46) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e64f8ce-6711-4fc7-72ca-08da590d17a4
X-MS-TrafficTypeDiagnostic: IA1PR12MB6459:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oGwcuUbRDa27f51/gJACHrcrIsdY5UZljJLwbJA28WPzOSUctdP6G5uXW9xnwJ2FeThBuTz1GUbfq4z3hS0z4YQiujQhbLUA4jMjcQFtQduQ8253WZLxdFJ1BWB+8RYDd0u078Zbbaf/9g7VIHZzHZqAJa4KHpu0jtYqZ3hL3de8aEIn5ZRqeCkqBClzsszADR3fXDJQ56ptRVdtU4H51uQOSBnSLvGuxnZQNEAEy52Pb0d22jx9t3vBYpjJxFxJa+FSL9JuqBoCEO13vtehTNQX2q+5RdSHAY5veuz0h+YrqQv7Djt6t0po8Dn4xJkN0lTUMev7WntsH9NWrPNQ1h6qYcYQ5TLFIuQ0vFnq6n7pzEA6C69kY4Wrok7a90+Sy8VvCt88H7JaRtiQYEG8CdwLkY16Qzw4AMGeIFnQwwNcqq3p7C81J4/jnB4I22YaqBi7VkfZItPy5LR3pQlawy4rNdF38ca+P8D2a3BWrBVUIpTEkjE2dDykXFPOr8p7GEvZb3ho2HQnC5tsHWYn8XuFZ+kwjtJ2bWyellQXf5krxU0DicLDZheuRWvl0EEaiNlmqtxYbKkvkwy2luhIROdkuQdk5mWJlm37h+aig8b+IfwlyUmI7KahLDLhg5uul0+aTZF63Ewz0xUrUojBpjMCZoCAmypPLkcs2kPDnvUnmdXsQRcpIstl6GpWVrz2qG2xLzaIzsKyGxzHEU0WkNC04/M8MqN9TXYsOfuUhDjElE7LQSqa8H7hC2yDVUEjuOA8f9Ff4p36r3NUhwlcSCJJVRbyGUFIII2s4w6Rl+0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(2616005)(53546011)(41300700001)(1076003)(5660300002)(38100700002)(6512007)(26005)(86362001)(83380400001)(478600001)(36756003)(66946007)(33656002)(2906002)(186003)(66476007)(8676002)(4326008)(66556008)(6506007)(6486002)(7416002)(8936002)(6916009)(316002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGJ5ZlJoK3FHWEc1aWljRmVuRDZ4RnY2SkpBNStBMi85V3E5MHJrczExRFZr?=
 =?utf-8?B?blhSTUd6dFJncTQvNDhEZUpycG02VGN0c2pHSEdzZ2JuUTl4WHpJcW9Ibmh6?=
 =?utf-8?B?V2hxQUU4NTFHSldYdE53Q0dlcEthYWpGamJwdWk2VVN1T0NJdVpIcldNVFov?=
 =?utf-8?B?NFJjaExIeGVWR05HNEpRcHVGdFN2WlU1OHBjOFVZZVJ2VXh4K3o0dzFQM2NE?=
 =?utf-8?B?VmM2akdwd2dvNGZXNGhmR3MrekMrQXBsTStyZkR6RGdaVUdtRGMvc25McUpD?=
 =?utf-8?B?OS9XRkVRc1ZDdXFNK3FKT1kwd0d4ckdoSzFseTU2UFZoTTl5V1RnMEE5YjFs?=
 =?utf-8?B?SHdwQmF0S0tiT1dxckZGMG4xelRTcUhhTVIvNDNSV04wNnFaME5lWE53TzhB?=
 =?utf-8?B?cW1NTHM4ZWt1bDkwOTNNUk11cXQzcTVFdWE2dE5Cd2xTRk9xVEhDVG4xUWNO?=
 =?utf-8?B?NkppSmkrRzI5cDZQaXdXcUtCMzFsQ3F3YjJja09zR0NUK2RFYUt2YkdHbkZ0?=
 =?utf-8?B?VC80QnhURGdUbFV5OG83aVkrL2hIdDlkc09WUTZoYlFZa1NoREdaYXRpUGIx?=
 =?utf-8?B?NTdpSG1zZlN0TC9Ra1loYlZRTldBL1hBZUxhclNBR1Q4SFdEUWJlS1FuQTBM?=
 =?utf-8?B?dkNHZkJ4dlNvNktLRGtRa1B0OHYvalRML295czMrcS9Sb0RFTitDNTVqeWZX?=
 =?utf-8?B?Nk5MRDZTa0N0T0xXbVdnbXZ4UTVuM01KT01Kdk5pSmxHNWN5eXBUalNHKzNP?=
 =?utf-8?B?ZnlmS1cvblRiblEySEtUYml2SFBybzl2eXI2YTNhbWtYNkdRNnBucGRuN1NE?=
 =?utf-8?B?dERDdTJKQUpjVDBIWVUvTVJUUEExU0JFblh4S2I5dEtvdlFOQ1hBZ00yTDBD?=
 =?utf-8?B?QXQvZk9ZdEV3NVNZQjNzbDNIU21GNkRPdUJTcHRKUzZBVDNmRXZ4eUZabERQ?=
 =?utf-8?B?clJ3YVh2U0lZVWsxeGxZbEJVVEorYUFpVUlBbjhtNzNJSjdVa2JMa3BqV0l5?=
 =?utf-8?B?VjkyTFd3U0NhRW04NFp2VFYxL3hLS0RNWkFVcS9DbHRSNnUwYkF4V0VqUkhr?=
 =?utf-8?B?YlUzelpoR3QzVGJCL2dmRW5QQ09vdEpnVmxJV2VBQmZKYVhmWURVWGpHMCt0?=
 =?utf-8?B?S21jZWVhc29sdVF6aElJbWhWVUk2K3llK2duYzlOYVFxOHUrc0t3WTdmNE12?=
 =?utf-8?B?eUtxTHNzVHhMYVdacFdQbmxxNXZEMVprMG9YbHNpTzZORE1kTU9UNDR5ZGlr?=
 =?utf-8?B?bXdWVHJNdUdiMzV4a2tjd09kTXByMXJpUFJycmVnNTA3a21vNENjTXlyckRL?=
 =?utf-8?B?eTBBTDB5ek02OU5kMVNEK1ZpN20zQVdkWW9GYzlYQkxqeTNlRXJ6WTFDck1r?=
 =?utf-8?B?dGkzMUdTNFlLWVhBaU04VXNjdVhJT0lkQUNkR0xEWVg0YkRJWkdMeGp0aFNi?=
 =?utf-8?B?NSt1RURtZXRiOTNKS0Vzbkl0bGlQZngvbDg5Uml2Ri9jNzkxOU5MOCtQSmo5?=
 =?utf-8?B?bFhGaHB3S3pmK1p0bHZKZWdFT29PSEpPZGdmVEpTWWljbmRUV1pUa0VJemdL?=
 =?utf-8?B?aTluQWVpQ1FaQzFGYWRYTnNsUlM0VktDVU9tVHkyVm05Qk54NGNnVDRQd0pQ?=
 =?utf-8?B?SkZScTVuWnNtRnd4NDViMmozcENvMFRyOG4wNlBoemJUV3ZLdmRDZFhJb1F0?=
 =?utf-8?B?bkliREs2ZHZXa2RPOGluRWlrTlpYOGlhSEg0Vys5RG14YURxa3FqRWl1bzd3?=
 =?utf-8?B?a0RZblhsUG1saGFZaTdoSTVxMVRaRVB1QU9IWlU5UnhTM3FzbmZGcXdWOXBp?=
 =?utf-8?B?N054U090SSt0TGw2aFdyYnNFSEE5WW15OTdkcmJtSGRjeWhMTktTNDM0UUJO?=
 =?utf-8?B?bkxMMW1ZS1BsWTRRVHpSUFdTZDZPbTl3SDBXQ0pRK3pmYkRZRU9GVmErR2VW?=
 =?utf-8?B?S1Z6WVdURlJEcW9TUW9VaTJGTVhPVDRFdXUrWWhHZnIzSkNESDNURDQwYWQr?=
 =?utf-8?B?MUpZNVo1dWNkRU9iNVJRSmQxeHVUemJhcnBVeHpJMjNXeWVFWkt0U0lkbHY5?=
 =?utf-8?B?RXN4OE42eGRLQ1pzMHhNeUpMeWlvdGdlb2tERlNWSG1ZRW5QLzlUV0dKYnd1?=
 =?utf-8?Q?SHrsnJyR7bQkZyrwLp0xkQQ1F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e64f8ce-6711-4fc7-72ca-08da590d17a4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 13:49:59.3708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n6gghgjz2DjikQueBie0IRvPYDDUELfzUUeZSe5HRPm3r4qUODL8Ynr8Ce1LNv1K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6459
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 09:40:01AM -0400, Matthew Rosato wrote:
> On 6/28/22 8:35 AM, Christian Borntraeger wrote:
> > Am 27.06.22 um 22:57 schrieb Matthew Rosato:
> > > On 6/6/22 4:33 PM, Matthew Rosato wrote:
> > > > Enable interpretive execution of zPCI instructions + adapter
> > > > interruption
> > > > forwarding for s390x KVM vfio-pci.  This is done by triggering a routine
> > > > when the VFIO group is associated with the KVM guest, transmitting to
> > > > firmware a special token (GISA designation) to enable that
> > > > specific guest
> > > > for interpretive execution on that zPCI device.  Load/store
> > > > interpreation
> > > > enablement is then controlled by userspace (based upon whether or not a
> > > > SHM bit is placed in the virtual function handle).  Adapter Event
> > > > Notification interpretation is controlled from userspace via a new KVM
> > > > ioctl.
> > > > 
> > > > By allowing intepretation of zPCI instructions and firmware delivery of
> > > > interrupts to guests, we can reduce the frequency of guest SIE exits for
> > > > zPCI.
> > > > 
> > > >  From the perspective of guest configuration, you passthrough
> > > > zPCI devices
> > > > in the same manner as before, with intepretation support being used by
> > > > default if available in kernel+qemu.
> > > > 
> > > > Will follow up with a link the most recent QEMU series.
> > > > 
> > > > Changelog v8->v9:
> > > > - Rebase on top of 5.19-rc1, adjust ioctl and capability defines
> > > > - s/kzdev = 0/kzdev = NULL/ (Alex)
> > > > - rename vfio_pci_zdev_open to vfio_pci_zdev_open_device (Jason)
> > > > - rename vfio_pci_zdev_release to vfio_pci_zdev_close_device (Jason)
> > > > - make vfio_pci_zdev_close_device return void, instead WARN_ON or ignore
> > > >    errors in lower level function (kvm_s390_pci_unregister_kvm) (Jason)
> > > > - remove notifier accidentally left in struct zpci_dev + associated
> > > >    include statment (Jason)
> > > > - Remove patch 'KVM: s390: introduce CPU feature for zPCI
> > > > Interpretation'
> > > >    based on discussion in QEMU thread.
> > > > 
> > > 
> > > Ping -- I'm hoping this can make the next merge window, but there
> > > are still 2 patches left without any review tag (16 & 17).
> > 
> > Yes, I will queue this (as is). Ideally you would rebase this on top of
> > kvm/next but I can also do while applying.
> > Let me know if you want to respin with the Nits from Pierre.
> 
> Ah, sorry -- I assume you mean Paolo's kvm/next?  I tried now and see some
> conflicts with the ioctl patch.
> 
> Why don't I rebase on top of kvm/next along with these couple of changes
> from Pierre and send this as a v10 for you to queue.
> 
> While at it, there's one other issue to be aware of -- There will also be
> small merge conflicts with a patch that just hit vfio-next, "vfio:
> de-extern-ify function prototypes" - My series already avoids adding externs
> to new prototypes, but adjacent code changes will cause a conflict with
> patches 10 and 17.
> 
> Not sure what the best way to proceed there is.

You should use a branch based on vfio-next and send a Git PR to Christian
and Alex

Jason
