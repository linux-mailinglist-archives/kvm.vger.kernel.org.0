Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C48B5F4CE9
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 02:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJEAIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 20:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJEAIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 20:08:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F2D6E8BC
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 17:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664928525; x=1696464525;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ndz+r2vd3E0o3GtnwGmf66mX4wbFs1JwE/pM0Yr32O0=;
  b=oJtiUNajAhgasNzWt8vGZoXHlE7wjFdpHwwZE8X11zMAyhpP151goFnP
   +NmzQ9ApryQaWJRdjCGUmkcnRJDkV3+hF/LbE9S4IaO1BbnK8TE6tS31i
   j29I+cQW28uGFAvolUyK3PwjuCoO3woWrebbSCz1m113hn8J/knUBh4hr
   o4ctnjbbAT1l9uhpdGmIf9o1wmsnRDGk7mZjUygtNAB7j9dMa+HpxoZTd
   586zPT/nbdIf9eSH9T2v1oD08I9aJuOxWQRg1ybUaDNcL4nn3z/QFY6eC
   m3+YbEoGHahlpeJTnjN8lAAGf2jqCIyovorZnV1RU7nOlxrOr84B/48CN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="303034488"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="303034488"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 17:08:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="654991969"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="654991969"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 04 Oct 2022 17:08:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 4 Oct 2022 17:08:44 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 4 Oct 2022 17:08:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 4 Oct 2022 17:08:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 4 Oct 2022 17:08:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=juZBy9UyUl6W1kFZRuJSC1/ehnUdcKY53AvgGu2SFYJI4lxX44S0qX6FMkHrIV1j1QGopvAxwKh+Jg7zMIJyHeuFdpyVkMtqnaSpc8nqVbIyzQ2J+Py99nM9R6ICSbFk1sJ0rA6YKkjHXCsiTBlxxKNHYgetvNxIVGgwXE4tBibIaCOQY1+7rEBUmYhlNysbSzEYwdOitK5T0ZxRI3No8SVHvupssvsMeQLPCRyC6463d9U6H9Y8gRGK/mf6onwEsq0fHYILwulLetaqKRivP8u/kBbXkgeOcthSq5JxI9KwQyBYIArGE9hG8slJUs1+6W7yd/ZQvufV6r9QXrlb4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ndz+r2vd3E0o3GtnwGmf66mX4wbFs1JwE/pM0Yr32O0=;
 b=NZrwYWHP1Jg31GBFZjbCucnjRFSwth/A8XXPsxDBeoR43ZJQ4Uugf4sOCSrE74Yly4Tu5kDkQrt+9CHeE9DLbBHx773BIUXOPhsMYUfNsI4YpvpxfYG8PXtHM2vBunG7BfZa/YzlU/3LV4F8JvE1B8gDJwtsPYCtcCPXNY/MuFBvCUPKYjzVl43t3pIyIXYCkDbJHmPj6oVlgrhVYGyqCscX3CYEeFmCtim2C8mvM/Z8yR8zF1/A65invTMduW4RA/MjqYdtVYtB5qE5/LWvp75at/qe58m75yxjp8iyb8SO1+GkJfYZRs7hVJW4ptKcY+RRmdo59vWrLPmo8xGOXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by CY5PR11MB6368.namprd11.prod.outlook.com (2603:10b6:930:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.31; Wed, 5 Oct
 2022 00:08:41 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::b52e:e73e:ac99:8a5]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::b52e:e73e:ac99:8a5%3]) with mapi id 15.20.5676.031; Wed, 5 Oct 2022
 00:08:41 +0000
From:   "Dong, Eddie" <eddie.dong@intel.com>
To:     Jim Mattson <jmattson@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: RE: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
Thread-Topic: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
Thread-Index: AQHY1FYuEs8BAKsu5UCBOzB/nmNIY634etfwgAAg0oCAAAmBoIAADbaAgARdgACAABF6gIABzqOw
Date:   Wed, 5 Oct 2022 00:08:41 +0000
Message-ID: <BL0PR11MB30426E91DB220599F53F577F8A5D9@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <20220929225203.2234702-1-jmattson@google.com>
 <20220929225203.2234702-2-jmattson@google.com>
 <BL0PR11MB304234A34209F12E03F746198A569@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eSMbLy8mETM6SRCbMVQFcKQRm=+qfcH_s1EhV=oF656eQ@mail.gmail.com>
 <BL0PR11MB30421511435BFEF36E482AC28A569@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eTNeeCNt=xMFBKSnXV+ReSXR=D11BQACS3Gwm7my+6sHA@mail.gmail.com>
 <BL0PR11MB3042784D7E66686207D679268A5B9@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eRJOHwh1twmS5X+ooGQqn+y0YrNXgJoB7UhMb+nUa+EFw@mail.gmail.com>
In-Reply-To: <CALMp9eRJOHwh1twmS5X+ooGQqn+y0YrNXgJoB7UhMb+nUa+EFw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3042:EE_|CY5PR11MB6368:EE_
x-ms-office365-filtering-correlation-id: 8e53c909-c031-413c-a6c1-08daa665c290
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jv+j3PtY4EcVYLUJ/dFTLnrqgq8KA6gAfMgj7IJTNXNX05brXK3QqD28+Qpedi1dul/tUj2Qjke0f0Fgh/qgyWQhQjOrEs83R/csJ6Y90odSqh3vynoZBKtWab1mqdzzovV135DuNofrZeXuCh4T6QU8bmZ4aWJFYGWgkBxutQtiCjdC2pYLGg6Xccg0xxvYvuSoj01IT4ej3gKJSef3L4LwG5wEcd2Lc4fUBEXoVb9TQs1DKR6wy+XA9OECxKdFhmqNex7qA465kIEmeCQETxQdWKSWwcCVdL2r6qA/yR69K06vZd17YO2hZt2dj/ohiZGA66hIT9tUdSLUdfb6f8gXwQg7BKcTxN0JKhZbG6iOhdhGAtBY7TYhG5CqFbrCNRTK36AqlErfD1qaEIFEsVStcti1p6GpHqhavahWQ83PjFkkOqUOEku8Vx5uvgQVet3SJtF5WD/r4X3AdRqb+P6QVHSH1IEXsxG0By9epGqgcracobqRdaLlmWn0STWqCT0W7uk5lgS0blVHOvEKFO/FtppjnFk8AivSmpkZ/R0rYcIczamj6BJNR16dzryad/vv3VPJTOYzQ9DzUdw2Vcq/XUiE7o3+C35aWnH0vkmykZN5JtAPsyNB5v8K7oKrxxOjhkCuoyJPZhsdfWZkzbCUKL+p/u7e8IYMC0bcNpYzZy7xPxfh0IgkzpKGHsUIRSJLJDJ5FS4Ed7eyXE6zNEOM7Jk3Y0VPVCkRNCgX/LdJ0WpGP+crUfJjVKK0bvmFg0Cew9yKQ+/ujcjPs1C+cQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(39860400002)(346002)(366004)(451199015)(33656002)(186003)(2906002)(71200400001)(558084003)(54906003)(6916009)(122000001)(66946007)(41300700001)(478600001)(76116006)(7696005)(8676002)(66446008)(66556008)(66476007)(4326008)(64756008)(9686003)(55016003)(38070700005)(52536014)(5660300002)(6506007)(26005)(86362001)(8936002)(316002)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blArTU8zU3NwemNZN21KU2FjcG9zcWU0dTF2QmdTUU5xQVcxVElwWmpVK0dH?=
 =?utf-8?B?RkF4ekcvejQ2S3B6aWFocUdFTHFHTlpTeFNCQyt1RnRYWFZ5cTUxU29xeFhO?=
 =?utf-8?B?K2R6bTUrWURGbWpVeUtUN0pSeCt4bHljY1M2NUszZ0hvL0RzTDRSY05PVTRK?=
 =?utf-8?B?dmRXOG02T3Ixd0ZJWSszTlBoTldnVFF0QUFpUHBRUEZzU2hhSGp5UEw2SDNv?=
 =?utf-8?B?TW9qTmpRYnJFeHhRM1hpelY3dXQ3dWc0OWQrRnEwSFZ3SDFDMk43dXMyR1Nl?=
 =?utf-8?B?dXZOODJpblRaR1VYTllyblRXUTE4ZjBCOWZqVlVzY1hPVEwrR29zU09acjBS?=
 =?utf-8?B?YmkzYjR2enZqYTh0MVpEM3FKTFRlalpkWlhyNzFCQzY0TlUzTE94MDdQbldz?=
 =?utf-8?B?RmlMaGJSbFFNRURDRDdkUkRObXh2OTN6RTBUM29FK0xjOEtwTVJFdjIwek05?=
 =?utf-8?B?ZUl6VlR4WEVzdkpKQ3J0dWx2bllRUEJLdEM2Y1JQU01YV3BqZEFSa1hndjRL?=
 =?utf-8?B?VHRJMTY4Zm9ES0VUYXloZXN4WjZNTzNNMnQvdW4zV3RtVmJYUWorZkxTOUNy?=
 =?utf-8?B?Ykk5MmtYc2c0TE1kR3FoMDlraTYzVHc3eUF4RDRWVEZhbVhKd0t2VWp5ZDlZ?=
 =?utf-8?B?SG1IcEFWckQ3Zmt5cU1iaUdyenpObTFpb3VwR1R2bjJLdmlvRjNqZ2pXUkpu?=
 =?utf-8?B?RUFUaDd0NHZ1Vi9RRnlrYVpQZXpUVmxCeXFHd3BqSWxiU084b1dEbWo4Vzd2?=
 =?utf-8?B?NnEvY3k5cjZkZWt1WkU3S1lJcjZteEdmLzZMbWxJOVF0c2N5RVEvT1JqYlNw?=
 =?utf-8?B?aUpXUzJLR1lQMndZaCtxWWU2ZzZhRkt0RnYvSGxIOG1qaklucUpxSnRLQkow?=
 =?utf-8?B?YWpZRjgrQmdYQnJSUkdmdkRJZ3RrazhwNUIxK1E1RG90NUpQLzZzajkrbkR0?=
 =?utf-8?B?bFhZYXFRRkFITG9GS0NVVi9NdWpqN3RrUTgwM09wcjg4eVBEd1hRYVFEYkJD?=
 =?utf-8?B?Q3BPMElHMEc4Y0dCRkF6OFNxbi84K0tYaGpEeWV1Q0ZrL3N3YXl4d040ZW1p?=
 =?utf-8?B?WGJjTGpoTHI5ZGRQdXR0RVpSZWxCMERTQm1RdzhDYTlkQjlzaktiVlRoejZM?=
 =?utf-8?B?TlZBUVl4ajJlV2F1Z1VMQkhIOVdEeHBwcUN6UnU3b0xnR3FlRGEzNEFsS3dp?=
 =?utf-8?B?UFY5Vms1Yzd4ZlhMc3A0endhWUJYNDF3M2NzWjhzSTlYQjBmOE5yWEJabHZt?=
 =?utf-8?B?K3JIMWRUaEhTcnprdnY0TWY3YjJBVlNvRnNoZXRuODFlZzZkZlg1dlFnVlc2?=
 =?utf-8?B?cEdBR0lRcHlyOGhFSlZPeTJUWUh5Q3Y2dXB3djE2cCtwcjdvSnpiclVKaVJh?=
 =?utf-8?B?ZXN6UXk1U0FNNjc1cC9ocDBOaGtGWXMyZGF4dmRtUE0zK2QvRHlTSU9FanNo?=
 =?utf-8?B?ZGh5NWlJSEFqK3h4YTFUaGphelY3MFdWd0xuOGluV2tRTGNMYXcwamFUaTND?=
 =?utf-8?B?VG1idWE1TjNFWmZTektQSm5XVDlMVUN0bEdLN29oNHBMOTh5UkFZYS8wdDVD?=
 =?utf-8?B?Y0pvaWF6YUdmSTF2UjFKeVA3TFZudkhHMldIVTkwMVY2OERubSttZ2JTZGFy?=
 =?utf-8?B?SnV0bmgwcWRmdy82SmRRNmlQazNlTHhsQVE0SHliaHF5Y2hyMFVKNnNOWmFK?=
 =?utf-8?B?NHBoeTE4OVRERHFUMWdwV1J0R25BV1FxZXpDVTJ2MmFyRHZWRE9nVjV2NlZx?=
 =?utf-8?B?WnhyMENpZmRTVFhqb3pqdUxFNG9yVUdqYVY5NW5POHZqYkZkSzZ6dmd6a01x?=
 =?utf-8?B?cmhYOWFHTjljaEtMUEZNNEg3UHpxOVBiVXJCaEV2TER2VGZKTDhDa0NnU2lP?=
 =?utf-8?B?UlNZbjh1b1BPMWx6QStHR0RicTRSTmtaY2lrZU5SZkxQcGcrQ1FsT1UrR0tn?=
 =?utf-8?B?b2pCSHQwd1J6M3N6eVFBVjA1RjlPQUpCczFWME50UHNJb3lTTHdQVmNWc3ph?=
 =?utf-8?B?Vng2NC9Mbm94VlVBd0lsWmEyVEJ3L0kyZ2RzM0dhcWVIM29zUkc3YkpMeEdS?=
 =?utf-8?B?a1BoclhLT2tQZFhYNWsvWTZpNFFpcnkxWVlaMlNnWERkU0JXRFB5Rm44NExo?=
 =?utf-8?Q?3Bc2DEDunMhXg65EZmoI7/dIC?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e53c909-c031-413c-a6c1-08daa665c290
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2022 00:08:41.2201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /urTNduY2mS8its5S9wJb6+RkdbMSSvyn15oF49oVUrzLX1Mr4wJ39pH7YXxwOqPg7JkFR4LQ4YU02k5APeGkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6368
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBIYXJkd2FyZSByZXNlcnZlZCBDUFVJRCBiaXRzIGFyZSBhbHdheXMgemVybyB0b2RheSwgdGhv
dWdoIHRoYXQgbWF5IG5vdCBiZQ0KPiBhcmNoaXRlY3R1cmFsbHkgc3BlY2lmaWVkLg0KDQplbnRy
eS0+ZWR4IGlzIGluaXRpYWxpemVkIHRvIG5hdGl2ZSB2YWx1ZSBpbiBkb19ob3N0X2NwdWlkKCks
IHdoaWNoIGV4ZWN1dGVzIHBoeXNpY2FsIENQVUlELiANCkkgZ3Vlc3MgSSBhbSBkaXNjb25uZWN0
ZWQgaGVyZS4NCg0K
