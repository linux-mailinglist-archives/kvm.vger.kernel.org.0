Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8E2544507
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 09:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbiFIHoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 03:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiFIHox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 03:44:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714591F2DE;
        Thu,  9 Jun 2022 00:44:51 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2596iOSO005945;
        Thu, 9 Jun 2022 07:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=IV3ZNYmjhwzHflxHbEfNGCjnBLNowyX0Pmlit7EAFno=;
 b=G15wwBU8ckeIM7S4aBZqdFnt6oUMIg8hGzWYj+Zl55zB1uzfS2fmAtRaeJB5kQCNQns6
 4lMocLeTivils1fS2wSKQay1opwqF4JgUdK6kSXjZR1Ua4zwYUIXU1WH2pJfogQG8PmM
 P7PmwoL5vcG8vXlKGFqxO8bJdKYKbgQa/Zyzzxd70lbeWaPCxYhKiBxkvovkRmUZRGT1
 yhbE4GvwUMb6xqD4ps+exZmBg63ytV3SmHKekaDXkss4lxdouB13Pg/FkZqYWqR8In8p
 sr1lFXBx0cULVTrQjgJ31NL95BF9vQtkSfF/qc8KoX9ARFJ2YkWe5UF0KWuc3suCUugK /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gkbv013qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jun 2022 07:44:50 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 259710rH013165;
        Thu, 9 Jun 2022 07:44:50 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gkbv013py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jun 2022 07:44:50 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2597KNm5024326;
        Thu, 9 Jun 2022 07:44:48 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3gfy19ej9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jun 2022 07:44:48 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2597iiY818284824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jun 2022 07:44:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2E674C046;
        Thu,  9 Jun 2022 07:44:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92EA14C044;
        Thu,  9 Jun 2022 07:44:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.52])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jun 2022 07:44:44 +0000 (GMT)
Date:   Thu, 9 Jun 2022 09:44:41 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 1/3] s390x: Test TEID values in
 storage key test
Message-ID: <20220609094441.282f0cb9@p-imbrenda>
In-Reply-To: <a6d1dfe0f9163650c8b3bb80065e12a1b190f97b.camel@linux.ibm.com>
References: <20220523132406.1820550-1-scgl@linux.ibm.com>
        <20220523132406.1820550-2-scgl@linux.ibm.com>
        <20220524170927.46fbd24a@p-imbrenda>
        <a6d1dfe0f9163650c8b3bb80065e12a1b190f97b.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6x7weEedKAuWpL_-2C3pGbUbZuw8-MKT
X-Proofpoint-GUID: RCLuyV2AgzyMPuJFJd0JJQqV_Bs6IWFK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-09_07,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 phishscore=0 mlxscore=0 bulkscore=0 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206090029
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 08 Jun 2022 19:03:23 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

[...]

> > > +		break;
> > > +	case SOP_ENHANCED_2:
> > > +		switch (teid_esop2_prot_code(teid)) {
> > > +		case PROT_KEY:
> > > +			access_code = teid.acc_exc_f_s;  
> > 
> > is the f/s feature guaranteed to be present when we have esop2?  
> 
> That's how I understand it. For esop1 the PoP explicitly states that
> the facility is a prerequisite, for esop2 it doesn't.
> > 
> > can the f/s feature be present with esop1 or basic sop?  
> 
> esop1: yes, basic: no.
> The way I read it, in the case of esop1 the bits are only meaningful
> for DAT and access list exceptions, i.e. when the TEID is not
> unpredictable.

I see, makes sense

maybe add a comment :)

> >   
> > > +
> > > +			switch (access_code) {
> > > +			case 0:
> > > +				report_pass("valid access code");
> > > +				break;
> > > +			case 1:
> > > +			case 2:
> > > +				report((access & access_code) && (prot & access_code),
> > > +				       "valid access code");
> > > +				break;
> > > +			case 3:
> > > +				/*
> > > +				 * This is incorrect in that reserved values
> > > +				 * should be ignored, but kvm should not return
> > > +				 * a reserved value and having a test for that
> > > +				 * is more valuable.
> > > +				 */
> > > +				report_fail("valid access code");
> > > +				break;
> > > +			}
> > > +			/* fallthrough */
> > > +		case PROT_KEY_LAP:
> > > +			report_pass("valid protection code");
> > > +			break;
> > > +		default:
> > > +			report_fail("valid protection code");
> > > +		}
> > > +		break;
> > > +	}
> > > +	report_prefix_pop();
> > > +}
> > > +  
> 
> [...]

