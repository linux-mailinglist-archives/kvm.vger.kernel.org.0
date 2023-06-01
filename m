Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD59719E44
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 15:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbjFANcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 09:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbjFANbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 09:31:55 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585691AB;
        Thu,  1 Jun 2023 06:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685626291; x=1717162291;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=syPCDtC4AVBwm40gkOz80zQYze0KsxOe1ppN+hbBeP4=;
  b=Oyyeq7aNDDoPzUTZo30uChrxrt7CQFFRhGFDxnnTxGg3x5Xdf2KJbTn9
   3wuKy9VxThMltk9eHFl4SXeaFvU7QcY1kUXGUxIn3DRFTOBeEHHu6sNqm
   HnjlCYoCE19OQBVW4KuPkL5oraNwXhVc72HiWvm/lm/dYrnCNBziUoLwf
   kc0Fx0XiaEwpdnhvbDdTmtHqjmdNLW8CK2C0kJ62qZFDcrnFkBRohSDM9
   1gF25AUrxQIudxRUsc/tqHEPk/AxoliSi+SjlF59ob/lEfI7FRdZtifJK
   IbhEzP5CyQYGDS70nvp6q9vitsvgWxZWRINGO949zRpnbJNgf5T2F2vi9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="383828421"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="383828421"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 06:30:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="819782671"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="819782671"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 01 Jun 2023 06:30:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 1 Jun 2023 06:30:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 1 Jun 2023 06:30:32 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 1 Jun 2023 06:30:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZdFg4X/vH16pYRFXugIbidUyOyMFMTLIy+TQXjJrzzJojApXq6zTV9PKM8vrFSQpB+O9jzPCncYTrUEDVJhEkvsXi0jBFERh9qlRmEfTfNu7Tg1fpOLtDCLmppISVPuI7pZGQkwwhPhv8NSyVS4rQGOY9ByDDX8DCWQLwLhkeXFKQvguR4Pevr2TrmZeIe7sFYgoBJvodNbLu0w249PqfSoNMAA5AEGis2FvHyli3qsf02fJ3RmwbsdHCPpSwr2S/Tm3yTGR5sglfeUECJTKS/d/4XGwKrpdLV7xrR+b7wZIXyqFNFpaSHE20+4/jRIu8dysQT0K1PieKDYe7pX6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=syPCDtC4AVBwm40gkOz80zQYze0KsxOe1ppN+hbBeP4=;
 b=RFuLYU3t7bNssHtyyG35Z9BIcJYqnXwxmnnI+LfDi5KyjRFnrdZDp+qwqyXzA/4D+9KNzcbFbz0UcYZpOXRzHWmQXV5lM+ttSZm570I4BAOxvlFLd32S7VHUg08RCviVZqpgRnZi9fqRKWmRqlnPW4xAScI7vMyB9MJKsLI9NQYMblxYwWnAwnMe9slE4V26FR4JNK+URKRmpd4YpD2MMCM4mciYcTeBft78B6GpnsByeiv9xW9iUt6fd+iB/uwlzpAJnK4yarmmMYH6SRSm1GOaCxPhGcZs5/bU692aFG0cZH7fYcJWsxRLXZlqR489mAwQNMXYpXycw541ViD8cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH7PR11MB8477.namprd11.prod.outlook.com (2603:10b6:510:30d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Thu, 1 Jun
 2023 13:30:29 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::14c:205:c858:1ef6]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::14c:205:c858:1ef6%7]) with mapi id 15.20.6411.021; Thu, 1 Jun 2023
 13:30:29 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "dmatlack@google.com" <dmatlack@google.com>,
        "mizhang@google.com" <mizhang@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Thread-Topic: [PATCH v2] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Thread-Index: AQHZUPwYxSWFJqdvM0K0D4p/iJpYU67xiL+AgISXfTA=
Date:   Thu, 1 Jun 2023 13:30:29 +0000
Message-ID: <DS0PR11MB6373F567D22270CA3CE86696DC499@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20230307135233.54684-1-wei.w.wang@intel.com>
 <ZAkZjzQ8pJQXQhJR@google.com>
In-Reply-To: <ZAkZjzQ8pJQXQhJR@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH7PR11MB8477:EE_
x-ms-office365-filtering-correlation-id: 964e9e11-5381-48a0-a8d9-08db62a45dc7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vh8D/eZncoTUkQJE+XFUGUFzSTlbTHuuC7Bu7U99qnagzEQcWpaTqU1i8/xmX8QEilI+PfaYsjGO2RiZY3/+f+XoOku2TQGQI/50joSMUg0+xf5jlChhqGfP0YdX5dHUCCC6yj1Smw88umGSz0Kp5Km8G4O+2wGRlGvGq6CBEM4HZpIDTap4DXGNxZhHJZXOuh1wTOvmrB2IEkhDUt2iflrgPDopDr9lbaeshq9mc9hsHtxHt7Ogg6yV0DTd87jGf5cdqOK1NHVejsmG7UKDjXdT9+VCnSKmHulTbbSHQrrs2XE6bqrdlQnUqLqQneKXk4mlWOu8fUcqg0ji6sGoR33jAKnOlVpI193RrWS3Z7+leTaQqPAKRPm8j4lziV3BKumfv8CUqS7MAOl0JpScpIvLIv65k1qIosBtFHbmfcC+U6IE3ST3KZWye3ZZ1wWfb2wMpKFTjvJ8aL5aRjdEFyLwye0phyKQ+l0yhzQZIrqEReC5UlglT97TusTtRRSbwzDcbc314YYr2R45qUKUnatiD1xBC/SdrQw6g9EQTpKCYZ77DW+UGedVcPEhUnRdI9qqp0PAzs844cmbO2kTdXZktcPeehr3m/ggA3MPn+jdkznsuXdTNv3kwTXA2l+c
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(39860400002)(376002)(136003)(451199021)(82960400001)(33656002)(478600001)(122000001)(54906003)(66556008)(7696005)(71200400001)(76116006)(66446008)(66476007)(66946007)(64756008)(41300700001)(38100700002)(26005)(8676002)(52536014)(8936002)(86362001)(5660300002)(55016003)(2906002)(4744005)(53546011)(83380400001)(186003)(6506007)(9686003)(4326008)(38070700005)(6916009)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?23mOP5CtrDs/lUERyvAA/4lTV4AuhCuKXxYmZYRg0KcHYfqQu8BT5JL8zj3k?=
 =?us-ascii?Q?OgxGaXBIJ5CUNjNrwl0UpFgl/Ra9apA8fOIcMxcT9kkkyFqBaQCaC5aKFxfn?=
 =?us-ascii?Q?CPp80/jwCOdhmKJlLUmrtCn7niY7EY4K4uQU/3Pp6mPIR4QT83cbEjs3iVXf?=
 =?us-ascii?Q?EAKwkPm7cIoPerGl/wuczfcji1ZFOVY8bX7zjlZzUzLdpxV55wRLcinH7ZVi?=
 =?us-ascii?Q?CCimnumIw6OXLgYVWZi+FH0TClRNWrWSAoMJi/uIuliH1rBtSCUed2mOXG8t?=
 =?us-ascii?Q?wMfRFRhP2KIAD+dBM8J+UuaMDfwLM5E7mHrcLNrBEQuiKMqOapjYxa1f7ilV?=
 =?us-ascii?Q?XV31etnEMri9HtBIXs8o+FQTtD5LQwSbydf2ouT4FsvBts0Lsn1HEeYZFLBF?=
 =?us-ascii?Q?GrT3ZkngfsyLrwstzm2P61c6yGF3fsjxNveq50Ylkk541OY2VM2F+UjuXMG5?=
 =?us-ascii?Q?xiBm4GCWHrExW/jKBs20jdITW0+mDC51GYTInIo1JxAT9Aq4lF0q6yePoH05?=
 =?us-ascii?Q?UU66pY3FSK0iZjA76DyZNIgLWhO7y2bwyAcoPU9gF/d2Xl4henY3gzglrmhF?=
 =?us-ascii?Q?zUTOQp36HgoAqzPZ9EbU/9jHT8iPsCRX4KAEMqh2iYP6Sh2kRBlPOdjdtT9c?=
 =?us-ascii?Q?o45mkyDZL/nuBIH3ccbWCmPNzwPg4DZrzm6av3iotQHlNdBsf6sgccbqixZS?=
 =?us-ascii?Q?5EZ7bjm6zFPasYl8TGN0S8M7H8F/VLXmf3q24E4oWNfMfIFaCEYbuJY0B2nq?=
 =?us-ascii?Q?Gu4JgLFZ4tE9XpdAaOy1kZX0kQ2nxffEyD6GLq1cYbROf/qtQSoZa8sDy19o?=
 =?us-ascii?Q?byaOb0yav4sVSTXYiavBQ9/KHj6MmbaR4vKW9V21BQy4PZ2u2N/GcRYdyiPE?=
 =?us-ascii?Q?kKE7FaeuT2MhPW+h3WSDFNsHOGWbg+MkOuPC5ORXsRixPLdSAgrCnIlL+GyU?=
 =?us-ascii?Q?KBF0iJMimS2Mx/MTXxMJJ6UkmDDurbU1vV6/PgOCWiPra/y6ZBV3bZiq1QT1?=
 =?us-ascii?Q?LY3ur8DOVqOLuwrkDVx0GVcr67qT59JpiOGfyweW0P+MZ5Hniy8TsDIUN81V?=
 =?us-ascii?Q?peWqCzCEJHJWCD7GY5MU28B1H0iCF/NTTkaUZfk/OUX3GTpccUjsceL8Izvi?=
 =?us-ascii?Q?/QWs9iZstGDPq9nTC6VpRO7ECWOQpjmr1Mxy8gNeFjfZDzrGDX6NDzZKokYn?=
 =?us-ascii?Q?SyEBnKBbtt+Tn5ElfANnpevCJ+za4W0vPOGai0xMO8oLVGdAOjG6vfkUH/FW?=
 =?us-ascii?Q?On355w/M8GLRKMWSUz8Nr1Sklojbt0IE2Hq5HgzL3aAhoYIGUBjXZboSDeKe?=
 =?us-ascii?Q?eMzQE8aQMwzKPIRLNSkrJN+n6J3HmplObjp9hcnDV+Dhlc1CT9JTo5eaVGKN?=
 =?us-ascii?Q?NeXTOStuE6FevwY8E4lnkZJu61+jEHB699PU208zEw57GjX4iwx5rUuwDIqw?=
 =?us-ascii?Q?uHssKoxH79Utrs65jqSRtgV3BXeOgw3EMLRV0pQmXgX/ApnOOMNZ55zBOhK5?=
 =?us-ascii?Q?1kFc9RGjTRnofO8rVSFG01E4XucORiLYR3vqS1DyzRlG/lU7ww6E+QQOm+ZJ?=
 =?us-ascii?Q?ed+u7pRccSyNOSFHw/c/U+z29+4pAH5YR6mvrEF/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 964e9e11-5381-48a0-a8d9-08db62a45dc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 13:30:29.0161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pV6ZL+O0Ktc4rZRTX59OpytsXlVqjvBAYr//rN3ZHxLeIxF1HCJhgd0zB3TBVzqdzWLSMiXgHX+3O2uloobKHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8477
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, March 9, 2023 7:26 AM, Sean Christopherson wrote:
> On Tue, Mar 07, 2023, Wei Wang wrote:
> > Current KVM_BUG and KVM_BUG_ON assume that 'cond' passed from
> callers
> > is 32-bit as it casts 'cond' to the type of int.
>=20
> You're very generous, I would have led with "Fix a badly done
> copy+paste ..." ;-)
>=20
> > Fixes: 0b8f11737cff ("KVM: Add infrastructure and macro to mark VM as
> > bugged")
> > Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> > ---
>=20
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Kind ping on this patch.
Seems it wasn't noticed for months. Just check if it would be good to be
merged or not proper for any reason?

Thanks,
Wei
