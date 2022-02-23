Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880AB4C19ED
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 18:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243271AbiBWReA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 12:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242934AbiBWRd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 12:33:58 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777EA54FA2;
        Wed, 23 Feb 2022 09:33:29 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NFJ3mc007703;
        Wed, 23 Feb 2022 17:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=X3U/Tx69BZex1BAIM+2U4fWBQxgbxoGuv6xHDjIFm/Y=;
 b=rg5TuWqJxBIOkMtFqVVP519VGFwWzWqwc5T1+EKHrhtN2QyRr3AUT1j2QBZnyNp2pBeD
 ApiwQ2iar2GMc6PF8qCZuwbCy9Xgh7pWVYE1untffjZdMZkbeOn5nLSxE2fwcpg4TThQ
 stgs/OiluMAUXDjAWwqmIA47UY6l0ap9rMdoaunpMMUci/SRHgXtFILiqtgoVgsarL6o
 6FcBxrG2JTzdfxkG3IuCuCZvQ6hdhyb4by0/+4n2rlmjEUmGqOJksM4o+Vj3xprpEswl
 3PmVFiTwJps4TcgW5KL+HzF4IPjYGPZ5NoOt3bjOKp1zUDi1rUTP4bued946C6TgCPCH hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edqf3k65n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 17:33:28 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NHJmKt027675;
        Wed, 23 Feb 2022 17:33:28 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edqf3k63u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 17:33:27 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NHSbtS027137;
        Wed, 23 Feb 2022 17:33:21 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3ear69a6y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 17:33:21 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NHXH6A54198638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 17:33:18 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1EA04204B;
        Wed, 23 Feb 2022 17:33:17 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E3A142047;
        Wed, 23 Feb 2022 17:33:17 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.74.176])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 17:33:17 +0000 (GMT)
Message-ID: <99ec1cf03d17b3de2d47c497882f091f922713bf.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 6/8] s390x: Add more tests for STSCH
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, Pierre Morel <pmorel@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, thuth@redhat.com,
        david@redhat.com
Date:   Wed, 23 Feb 2022 18:33:17 +0100
In-Reply-To: <04daca6a-5863-d205-ea98-096163a2296a@linux.ibm.com>
References: <20220223132940.2765217-1-nrb@linux.ibm.com>
         <20220223132940.2765217-7-nrb@linux.ibm.com>
         <04daca6a-5863-d205-ea98-096163a2296a@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YGgnOs_t1BU2zagkI2kXfiwjHNxT01oX
X-Proofpoint-GUID: 67LIQehrSHAjKCugolYGfPgZq0TF2Vo5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_09,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 spamscore=0 mlxscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230100
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-02-23 at 16:39 +0100, Janosch Frank wrote:
> On 2/23/22 14:29, Nico Boehr wrote:
> > 
[...]
> >   
> > +static void test_stsch(void)
> > +{
> > 
[...]
> > +       report_prefix_push("Bit 47 in SID is zero");
> > +       expect_pgm_int();
> > +       stsch(0x0000ffff, &schib);
> > +       check_pgm_int_code(PGM_INT_CODE_OPERAND);
> > +       report_prefix_pop();
> 
> Add a comment:
> No matter if the multiple-subchannel-set facility is installed or
> not, 
> bit 47 always needs to be 1.

Will do.

> Do we have the MSS facility?

Not an IO expert, but it seems like it's enabled by QEMU in pc-
bios/s390-ccw/main.c, css_setup(). The comment suggests it's always
there.

> If yes, could we disable it to test the 32-47 == 0x0001 case?

I see ioinst_handle_chsc_sda() in QEMU to enable it. Disabling only
works with a full reset of the CSS (see css_reset()) which can be
triggered from a subsystem_reset(), which basically means we need to
IPL. I think that's not really viable or do you see any other way?

Halil, Pierre, can you confirm?

> 
> > +}
> > +
> > +static void test_pmcw_bit5(void)
> > +{
> > +       int cc;
> > +       uint16_t old_pmcw_flags;
> 
> I need a comment here for further reference since that behavior is 
> documented at the description of the schib and not where STSCH is
> described:
> According to architecture MSCH does ignore bit 5 of the second word
> but 
> STSCH will store bit 5 as zero.

Will add the comment above the function, OK?

> We could check if bits 0,1 and 6,7 are also zero but I'm not sure if 
> that's interesting since MSCH does not ignore those bits and should 
> result in an operand exception when trying to set them.

I already have a test in MSCH which checks for the operand exception.
It's simple enough to extend it to do a STSCH after the MSCH and check
the respective bits is clear. Will be added in v4.
