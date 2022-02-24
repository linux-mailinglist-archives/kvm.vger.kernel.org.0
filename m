Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E4E4C2083
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 01:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245221AbiBXAOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 19:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239973AbiBXAOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 19:14:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC295F4D1;
        Wed, 23 Feb 2022 16:14:11 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NLhq6Q026619;
        Thu, 24 Feb 2022 00:14:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=GhboOXHgk3Su1hpuvZIuOcREjqdoASGy2DRZzIEOD0w=;
 b=KJWWyU8pdsTZTerTRF+VDBiE6eldBoftdcYkhgHSznKlEdfaAEKEhMa3K5HBsbOEPeAM
 zojoNE2KUVnIUKn/Omj0FUWJFj5dM342GeaW4fWcyxKFrc1gG/quZ1zdze6Gi83fC3NE
 EIOshF5D1spwwfoMZj3AsUkYyugbZi7MjX0SwGsZ8qNUfoqKAVnq9B5vUPsdilX1nBry
 yv5gHowtYfnG2lbkNFFz3ffTF4oP9IeAoUTevH/drOq69WXOUWX11K16FicEArni/CSk
 9xRcXr4G83aTeWCQabCtv6k+IFsm9a4nRfKG4NHAtZXh4VIFrzZhdgGE0jNMGJDjpQDA Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edw3bjja4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 00:14:10 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21O0CHVh005761;
        Thu, 24 Feb 2022 00:14:10 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edw3bjj97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 00:14:10 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21O07m9r026156;
        Thu, 24 Feb 2022 00:14:07 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ear69de68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 00:14:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21O0E3Rv47186394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 00:14:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0595E4203F;
        Thu, 24 Feb 2022 00:14:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C93142041;
        Thu, 24 Feb 2022 00:14:02 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.69.173])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 24 Feb 2022 00:14:02 +0000 (GMT)
Date:   Thu, 24 Feb 2022 01:13:59 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Pierre Morel <pmorel@linux.ibm.com>, thuth@redhat.com,
        david@redhat.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 6/8] s390x: Add more tests for STSCH
Message-ID: <20220224011359.59572002.pasic@linux.ibm.com>
In-Reply-To: <99ec1cf03d17b3de2d47c497882f091f922713bf.camel@linux.ibm.com>
References: <20220223132940.2765217-1-nrb@linux.ibm.com>
        <20220223132940.2765217-7-nrb@linux.ibm.com>
        <04daca6a-5863-d205-ea98-096163a2296a@linux.ibm.com>
        <99ec1cf03d17b3de2d47c497882f091f922713bf.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SzAWcnfsc4IWYZEIta4IGSW8Bbe8kO86
X-Proofpoint-GUID: EgVMsl5ni9KDHOE2Zx649PwF8lEkAMMS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_09,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 adultscore=0
 phishscore=0 impostorscore=0 spamscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230136
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Feb 2022 18:33:17 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Wed, 2022-02-23 at 16:39 +0100, Janosch Frank wrote:
> > On 2/23/22 14:29, Nico Boehr wrote:  
> > >   
> [...]
> > >   
> > > +static void test_stsch(void)
> > > +{
> > >   
> [...]
> > > +       report_prefix_push("Bit 47 in SID is zero");
> > > +       expect_pgm_int();
> > > +       stsch(0x0000ffff, &schib);
> > > +       check_pgm_int_code(PGM_INT_CODE_OPERAND);
> > > +       report_prefix_pop();  
> > 
> > Add a comment:
> > No matter if the multiple-subchannel-set facility is installed or
> > not, 
> > bit 47 always needs to be 1.  
> 
> Will do.
> 
> > Do we have the MSS facility?  
> 
> Not an IO expert, but it seems like it's enabled by QEMU in pc-
> bios/s390-ccw/main.c, css_setup(). The comment suggests it's always
> there.
> 

AFAIR. The MSS facility is unconditionally implemented by QEMU thus
it is always indicated as installed, but lies dormant per default
and needs to be enabled.

The idea is that a non-enlightened OS would not enable the facility,
and thus effectively end up specifying zeros and using the
subchannel-set 0, and would observe no changes whatsoever compared
to running on a machine that does not have MSS facility installed.

Whether MSS is installed in some configuration or not can be detected
via the facility bit 47 of Store Channel-Subsystem Characteristics.

> > If yes, could we disable it to test the 32-47 == 0x0001 case?  
> 
> I see ioinst_handle_chsc_sda() in QEMU to enable it. Disabling only
> works with a full reset of the CSS (see css_reset()) which can be
> triggered from a subsystem_reset(), which basically means we need to
> IPL. I think that's not really viable or do you see any other way?
> 
> Halil, Pierre, can you confirm?

I don't think there is an other way, and there is usually no good reason
to attempt that. If your OS enables it is enlightened, and it won't
become non-enlightened. It is basically an opt-in. Eventually you may
want to IPL something different, and you are covered by the subsystem
reset.

The best way to test this would be to not enable the facility. I have
no idea if there is a way for a kvm-unit-test to accomplish that.

Regards,
Halil
